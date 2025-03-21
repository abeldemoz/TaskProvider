//
//  LegacyMutex.swift
//  TaskProvider
//
//  Created by Abel Demoz on 21/03/2025.
//

import Foundation

public class LegacyMutex<Value: Sendable>: @unchecked Sendable {
    private var value: Value
    private let lock = NSLock()

    public init(_ value: Value) {
        self.value = value
    }

    public func withLock<Result>(_ body: (inout sending Value) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }
        return try body(&value)
    }
}
