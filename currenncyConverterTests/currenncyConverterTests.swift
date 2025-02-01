//
//  currenncyConverterTests.swift
//  currenncyConverterTests
//
//  Created by Anjali Pandey on 01/02/25.
//

import XCTest

@testable import currencyConverter


class MockCurrencyAPIService: CurrencyAPIService {
    var mockExchangeRate: Double?
    var mockCurrencyCodes: [String] = []
    
    override func fetchExchangeRate(from: String, to: String, completion: @escaping (Double?) -> Void) {
        completion(mockExchangeRate)
    }
    
    override func fetchCurrencyCodes(completion: @escaping ([String]) -> Void) {
        completion(mockCurrencyCodes)
    }
}

final class currenncyConverterTests: XCTestCase {
    var viewModel: CurrencyConverterViewModel!
    var mockService: MockCurrencyAPIService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockService = MockCurrencyAPIService()
        viewModel = CurrencyConverterViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockService = nil
        try super.tearDownWithError()
    }
    
    func testFetchCurrencies() {
           let expectedCurrencies = ["USD", "EUR", "INR"]
           mockService.mockCurrencyCodes = expectedCurrencies

           let expectation = self.expectation(description: "Fetch currencies")
           viewModel.fetchCurrencies()

           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.viewModel.currencies, expectedCurrencies)  // Mock failure as doesnt fall into expectation
               expectation.fulfill()
           }

           waitForExpectations(timeout: 2, handler: nil)
       }
    
    
    func testConvertCurrency_ValidAmount() {
            viewModel.amount = "10"
            viewModel.fromCurrency = "USD"
            viewModel.toCurrency = "INR"
            mockService.mockExchangeRate = 80.0 // Mocked exchange rate
            
            let expectation = self.expectation(description: "Currency Conversion")
            viewModel.convertCurrency()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertEqual(self.viewModel.convertedAmount, "866.65")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 2, handler: nil)
        }

    func testConvertCurrency_InvalidAmount() {
          viewModel.amount = "invalid"
          viewModel.convertCurrency()
          
          XCTAssertEqual(viewModel.convertedAmount, "Invalid Input")
      }

    
    func testConvertCurrency_FailedConversion() {
           viewModel.amount = "10"
           viewModel.fromCurrency = "USD"
           viewModel.toCurrency = "INR"
           mockService.mockExchangeRate = nil // Mocked API failure
           
           let expectation = self.expectation(description: "Currency Conversion Failed")
           viewModel.convertCurrency()
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertEqual(self.viewModel.convertedAmount, "Conversion Failed")
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 2, handler: nil)
       }
       
       func testSwapCurrencies() {
           viewModel.fromCurrency = "USD"
           viewModel.toCurrency = "INR"
           
           viewModel.swapCurrencies()
           
           XCTAssertEqual(viewModel.fromCurrency, "INR")
           XCTAssertEqual(viewModel.toCurrency, "USD")
       }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            
        }
    }

}
