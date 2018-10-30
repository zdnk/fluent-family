import XCTest
@testable import Family

final class FamilyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Family().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
