// BloomFilter.swift
// 6/29/2020

import Foundation

public struct BloomFilter<T: Hashable> {
    private var data: [Bool]
    private var seeds: [Int]
    
    public mutating func add(_ value: T) {
        self.hashes(for: value)
            .map { abs($0 % data.count) }
            .forEach { data[$0] = true }
    }
    
    public func contains(_ value: T) -> Bool {
        self.hashes(for: value)
            .map { abs($0 % data.count) }
            .allSatisfy { data[$0] == true }
    }
    
    // likely to be deprecated in near future
    public init(size: Int, hashCount: Int) {
        assert(0 < size)
        assert(0 < hashCount)
        
        data = Array(repeating: false, count: size)
        seeds = (0..<hashCount).map { _ in Int.random(in: 0..<Int.max) }
        
    }
}


fileprivate extension BloomFilter {
    func hashes(for value: T) -> [Int] {
        seeds.map { seed in
            var hasher = Hasher()
            hasher.combine(seed)
            hasher.combine(value)
            return hasher.finalize()
        }
    }
}
