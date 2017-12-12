import XCTest
@testable import swifty

class SwiftyTests: XCTestCase {

    func testSwiftyFoo() {
        XCTAssertEqual(swiftyFoo(), 5)
    }

    static var allTests = [
        ("testSwiftyFoo", testSwiftyFoo),
    ]
}
