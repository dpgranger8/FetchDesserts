//
//  FetchDessertsTests.swift
//  FetchDessertsTests
//
//  Created by David Granger on 5/21/24.
//

import XCTest
@testable import FetchDesserts

final class FetchDessertsNetworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Naming convention in use: test_unitOfWork_stateUnderTest_expectedBehavior
    // Use Given, When, Then as the test structure, alternatively use Arrange, Act, Assert
    
    func test_getMealDetail_network_failure() async {
        // Arrange
        let network = Network()
        let mealID = "12345" // Meal ID not associated with a meal
        let expectation = expectation(description: "getMealDetail should fail")
        
        // Act
        await network.getMealDetail(id: mealID) { result in
            switch result {
            case .success(_):
                XCTFail("Expected network failure, but got success")
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        // Assert
        await fulfillment(of: [expectation])
    }
    
    func test_getMealDetail_network_success() async {
        // Arrange
        let network = Network()
        let mealID = "52772"
        let expectation = expectation(description: "getMealDetail should succeed")
        
        // Act
        await network.getMealDetail(id: mealID) { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected network success, but got failure")
            }
        }
        
        // Assert
        await fulfillment(of: [expectation])
    }
    
    func test_getMealDetail_network_sendsBackExpectedResponse() async {
        // Arrange
        let network = Network()
        let mealID = "52772"
        let expectedResult = "https://www.youtube.com/watch?v=4aZr5hZXP_s"
        
        // Act
        await network.getMealDetail(id: mealID) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    // Assert
                    XCTAssertEqual(response.strYoutube, expectedResult, "The response object should contain this YouTube link: \(expectedResult)")
                }
            case .failure(_):
                XCTFail("Expected network success, but got failure")
            }
        }
    }
    
    func test_getDesserts_network_sendsBackExpectedResponse() async {
        // Arrange
        let network = Network()
        let expectedResult = "Apam balik"
        
        // Act
        await network.getDesserts { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    // Assert
                    XCTAssertEqual(response.meals[0].strMeal, expectedResult, "The response object should contain \(expectedResult) as its first item")
                    
                }
            case .failure(_):
                XCTFail("Expected network success, but got failure")
            }
        }
    }
}
