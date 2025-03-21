// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol TaskProvider: Sendable {

    @discardableResult
    func task<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never>

    @discardableResult
    func task<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error>

    @discardableResult
    func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never>

    @discardableResult
    func detachedTask<Success: Sendable>(priority: TaskPriority?, operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error>
}

public extension TaskProvider {

    @discardableResult
    func task<Success: Sendable>(operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never> {
        task(priority: nil, operation: operation)
    }

    @discardableResult
    func task<Success: Sendable>(operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error> {
        task(priority: nil, operation: operation)
    }

    @discardableResult
    func detachedTask<Success: Sendable>(operation: sending @escaping @isolated(any) () async -> Success) -> Task<Success, Never> {
        detachedTask(priority: nil, operation: operation)
    }

    @discardableResult
    func detachedTask<Success: Sendable>(operation: sending @escaping @isolated(any) () async throws -> Success) -> Task<Success, Error> {
        detachedTask(priority: nil, operation: operation)
    }
}
