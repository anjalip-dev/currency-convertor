//
//  CurrencyAPIService.swift
//  currencyConverter
//
//  Created by Anjali Pandey on 01/02/25.
//

import Foundation
import CoreData

struct ExchangeRateResponse: Codable {
    let conversion_rates: [String: Double]
}

class CurrencyAPIService {
    static let shared = CurrencyAPIService()
    
    
    func fetchExchangeRate(from: String, to: String, completion: @escaping (Double?) -> Void) {
        let urlString = "https://v6.exchangerate-api.com/v6/b144b0967234135e1f6f8d03/latest/\(from)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                
                ExchangeRateManager.shared.saveExchangeRatesToCoreData(baseCurrency: from, rates: decodedResponse.conversion_rates)
                
                let rate = decodedResponse.conversion_rates[to]
                DispatchQueue.main.async {
                    completion(rate)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    
    func fetchCurrencyCodes(completion: @escaping ([String]) -> Void) {
        let urlString = "https://v6.exchangerate-api.com/v6/b144b0967234135e1f6f8d03/latest/USD"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                let countryCodes = Array(decodedResponse.conversion_rates.keys) // Get only the currency codes
                
                ExchangeRateManager.shared.saveCurrencyCodes(countryCodes)
                
                DispatchQueue.main.async {
                    completion(countryCodes.sorted()) // Sorted alphabetically for better UI
                }
            } catch {
                completion([])
            }
        }.resume()
    }
}


