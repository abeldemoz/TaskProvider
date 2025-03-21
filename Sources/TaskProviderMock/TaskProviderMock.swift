//
//  TaskProviderMock.swift
//  TaskProvider
//
//  Created by Abel Demoz on 18/03/2025.
//

import TaskProvider
import Synchronization

public final class TaskProviderMock: TaskProvider, Sendable {

    public enum MethodCall: Equatable, Sendable {
        case task(priority: TaskPriority?)
        case detachedTask(priority: TaskPriority?)
    }

    public let log = LegacyMutex<[MethodCall]>([])
    private let completedTasksCount = LegacyMutex(0)
    private let tasksCount = LegacyMutex(0)

    public init() {}

    public func task<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never> {
        log.append(.task(priority: priority))
        tasksCount.increment()
        return Task(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            let result = await operation()
            return result
        }
    }

    public func task<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error> {
        log.append(.task(priority: priority))
        tasksCount.increment()
        return Task(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            do {
                let result = try await operation()
                return result
            } catch {
                throw error
            }
        }
    }

    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never> {
        log.append(.detachedTask(priority: priority))
        tasksCount.increment()
        return Task.detached(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            let result = await operation()
            return result
        }
    }

    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error> {
        log.append(.detachedTask(priority: nil))
        tasksCount.increment()
        return Task.detached(priority: nil) { [weak self] in
            defer { self?.completedTasksCount.increment() }
            do {
                let result = try await operation()
                return result
            } catch {
                throw error
            }
        }
    }

    public func waitForTasks() async {
        while completedTasksCount.value < tasksCount.value { await Task.yield() }
    }
}

// MARK: - Mutex Extentions

private extension LegacyMutex where Value == Array<TaskProviderMock.MethodCall> {
    func append(_ methodCall: TaskProviderMock.MethodCall) {
        withLock { $0.append(methodCall) }
    }
}

private extension LegacyMutex where Value == Int {
    func increment() {
        withLock { $0 += 1 }
    }
}

private extension LegacyMutex where Value: Sendable {
    var value: Value {
        withLock { $0 }
    }
}
