// BloomFilter.swift
// 6/29/2020

import Foundation

struct BloomFilter<T: Hashable> {
    private var data: [Bool]
    private var seeds: [Int]
    
    mutating func add(_ value: T) {
        self.hashes(for: value)
            .map { abs($0 % data.count) }
            .forEach { data[$0] = true }
    }
    
    func contains(_ value: T) -> Bool {
        self.hashes(for: value)
            .map { abs($0 % data.count) }
            .allSatisfy { data[$0] == true }
    }
    
    init(size: Int, hashCount: Int) {
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
