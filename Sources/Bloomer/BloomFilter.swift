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
    
    // likely to be deprecated in near future
    // (size is specified in number of bits)
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
