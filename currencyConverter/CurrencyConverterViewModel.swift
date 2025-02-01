//
//  CurrencyConverterViewModel.swift
//  currencyConverter
//
//  Created by Anjali Pandey on 31/01/25.
//

import SwiftUI
import Combine
import CoreData

public class CurrencyConverterViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var fromCurrency: String = "USD"     //default
    @Published var toCurrency: String = "INR"      //default
    @Published var convertedAmount: String = ""
    @Published var currencies: [String] = []
    @Published var exchangeRates: [ExchangeRate] = []
    @Published var isLoading = false
    
    private var currencyService: CurrencyAPIService
    
    init(currencyService: CurrencyAPIService = CurrencyAPIService.shared) {
        self.currencyService = currencyService
        fetchCurrencies()
    }
    
    func fetchCurrencies() {
        
        //First fetching the currency codes from Cache using Coredata
        if let cachedCodes = ExchangeRateManager.shared.fetchCachedCurrencyCodes(), cachedCodes.count > 0 {
            currencies = []
            cachedCodes.forEach { c in
                currencies.append(c.code!)
            }
            currencies.sort()
            return
        }
        
        currencyService.fetchCurrencyCodes { [weak self] codes in
            DispatchQueue.main.async {
                self?.currencies = codes
            }
        }
    }
    
    func convertCurrency() {
        
        guard let amountValue = Double(amount) else {
            DispatchQueue.main.async { // UI update must be on the main thread
                self.convertedAmount = "Invalid Input"
            }
            return
        }
        
        isLoading = true
        
        if let cachedRates = ExchangeRateManager.shared.fetchCachedExchangeRates(for: fromCurrency), cachedRates.count > 0 {
            exchangeRates = cachedRates
            
            if let rate = exchangeRates.first(where: { $0.exchangeCurrencyCode == toCurrency }) {
                let convertedValue = amountValue * rate.exchangeRate
                self.convertedAmount = String(format: "%.2f", convertedValue)
            } else {
                self.convertedAmount = "Conversion Failed"
            }
            
            isLoading = false
            return
        }
        
        currencyService.fetchExchangeRate(from: fromCurrency, to: toCurrency) { rate in
            DispatchQueue.main.async {
                self.isLoading = false
                if let rate = rate {
                    let convertedValue = amountValue * rate
                    self.convertedAmount = String(format: "%.2f", convertedValue)
                } else {
                    self.convertedAmount = "Conversion Failed"
                }
            }
        }
    }
    
    
    func swapCurrencies() {
        
        // Swapping the values of 'fromCurrency' and 'toCurrency'
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp
    }
    
}



