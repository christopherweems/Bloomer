import XCTest
@testable import Bloomer

final class BloomerTests: XCTestCase {
    static var allTests = [
        ("testExample", testExample),
        ("testMany", testMany),
    ]
}

extension BloomerTests {
    func testExample() {
        var filter = BloomFilter<String>(size: 512, hashCount: 6)
    
        XCTAssertFalse(filter.contains("yo"))
        XCTAssertFalse(filter.contains("no"))
        
        filter.insert("yo")
        
        XCTAssert(filter.contains("yo"))
        XCTAssertFalse(filter.contains("no"))
        
    }
    
    func testMany() {
        func fibs(through: Int) -> [Int] {
            return sequence(state: (0, 1), next: { (pair: inout (Int, Int)) -> Int? in
                defer { pair = (pair.1, pair.0 + pair.1) }
                return pair.1
            }).prefix(while: { $0 <= through })
        }
        
        var filter = BloomFilter<Int>(size: 1000000, hashCount: 6)
        
        let max = 100_000
        let fibNumbers = fibs(through: max)
        
        let nonFibs: [Int] = {
            let fibSet = Set(fibNumbers)
            return (0...max).filter { !fibSet.contains($0) }
        }()
        
        
        fibNumbers.forEach {
            filter.insert($0)
        }
        
        fibNumbers.forEach {
            XCTAssert(filter.contains($0))
        }
        
        nonFibs.forEach {
            XCTAssertFalse(filter.contains($0))
        }
    }
}
