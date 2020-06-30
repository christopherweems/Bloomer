import XCTest
@testable import Bloomer

final class BloomerTests: XCTestCase {
    static var allTests = [
        ("testExample", testExample),
    ]
}

extension BloomerTests {
    func testExample() {
        var filter = BloomFilter<String>(size: 512, hashCount: 6)
    
        XCTAssertFalse(filter.contains("yo"))
        XCTAssertFalse(filter.contains("no"))
        
        filter.add("yo")
        
        XCTAssert(filter.contains("yo"))
        XCTAssertFalse(filter.contains("no"))
        
    }
}
