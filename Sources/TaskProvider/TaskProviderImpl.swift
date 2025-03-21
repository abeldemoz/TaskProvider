//
//  TaskProviderImpl.swift
//  TaskProvider
//
//  Created by Abel Demoz on 18/03/2025.
//

struct TaskProviderImpl: TaskProvider {

    public init() {}

    public func task<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never> {
        Task(priority: priority, operation: operation)
    }

    public func task<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error> {
        Task(priority: priority, operation: operation)
    }

    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never> {
        Task.detached(priority: priority, operation: operation)
    }

    public func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error> {
        Task.detached(priority: priority, operation: operation)
    }
}
