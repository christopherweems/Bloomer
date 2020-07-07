// BloomFilter.swift
// 6/29/2020

import Foundation

public struct BloomFilter<T: Hashable> {
    private var data: Data
    private var seeds: [Int]
    
    public mutating func insert(_ value: T) {
        self.hashes(for: value)
            .map { abs($0 % bitCount) }
            .forEach { hashValue in
                let index = hashValue / 8
                let match: UInt8 = 1 << UInt8(hashValue % 8)
                
                self.data[index] |= match
            }
        
    }
    
    public func contains(_ value: T) -> Bool {
        self.hashes(for: value)
            .map { abs($0 % bitCount) }
            .allSatisfy { hashValue in
                let index = hashValue / 8
                let match: UInt8 = 1 << UInt8(hashValue % 8)
                
                return (data[index] & match) != 0
            }
    }
}


// MARK: - Initializers

extension BloomFilter {
    public init(estimatedCount: Int, falsePositiveRate: Double = 0.01) {
        assert(0 < estimatedCount)
        assert(0.0 < falsePositiveRate)
        assert(falsePositiveRate < 1.0)
        let estimatedCount = Double(estimatedCount)
        let falsePositiveRate = Double(falsePositiveRate)
        
        let bitCount = (-sqrt(2) * log2(falsePositiveRate) * estimatedCount).rounded(.up)
        let hashCount = (-log2(falsePositiveRate)).rounded(.up)
        
        self.init(size: Int(bitCount), hashCount: Int(hashCount))
    }
    
    
    /* size == bit count */
    
    public init(size: Int, hashCount: Int) {
        assert(0 < size)
        assert(0 < hashCount)
        
        data = Data(count: max(size / 8, 1))
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

fileprivate extension BloomFilter {
    var bitCount: Int {
        data.count * 8
    }
}
