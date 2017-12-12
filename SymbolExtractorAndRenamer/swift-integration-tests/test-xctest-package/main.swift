import XCTest

class MyXCTest : XCTestCase {
    static var allTests: [(String, (MyXCTest) -> () throws -> ())] {
        return [("test_example", test_example)]
    }

    func test_example() {
      print("HI")
    }
}

XCTMain([
  testCase(MyXCTest.allTests)
])

