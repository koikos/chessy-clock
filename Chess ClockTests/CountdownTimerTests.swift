//  Created by Michał Kozik on 04/02/2023.

import XCTest
@testable import Chess_Clock

final class CountdownTimerTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let timer = CountdownTimer(seconds: 10)

        timer.toggle()
        // Call performTask after a delay of 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.toggle()
            let result = timer.getRemainingTime()
            XCTAssertEqual(result, 9)
        }
    }
}
