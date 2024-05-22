//
//  FetchDessertsUITests.swift
//  FetchDessertsUITests
//
//  Created by David Granger on 5/21/24.
//

import XCTest

final class FetchDessertsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Naming convention in use: test_unitOfWork_stateUnderTest_expectedBehavior
    // Use Given, When, Then as the test structure, alternatively use Arrange, Act, Assert
    
    func test_button_showsMealDetail() {
        let app = XCUIApplication()
        app.launch()
        
        let cardButton = app.buttons["Apple Frangipan Tart"]
        let mealDetail = app.otherElements["MealDetail"]
        
        XCTAssert(cardButton.waitForExistence(timeout: 60))
        cardButton.tap()
        
        // Assert that the mealItem element exists after tapping the cardButton
        XCTAssertTrue(mealDetail.exists, "Meal detail should be shown after tapping CardButton")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
