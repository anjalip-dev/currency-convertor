//
//  ExchangeRateManager.swift
//  currencyConverter
//
//  Created by Anjali Pandey on 01/02/25.
//

import CoreData

class ExchangeRateManager {
    
    static let shared = ExchangeRateManager()
    
    
    func saveCurrencyCodes(_ codes: [String]) {
        let context = PersistenceController.shared.container.viewContext
        
        // First, clearIng existing currency codes
        let fetchRequest: NSFetchRequest<CurrencyCodes> = CurrencyCodes.fetchRequest()
        do {
            let existingCurrencyCodes = try context.fetch(fetchRequest)
            for code in existingCurrencyCodes {
                context.delete(code)
            }
        } catch {
            print("Error fetching existing currency codes: \(error)")
        }
        
        // Now, saving the new currency codes
        for code in codes {
            let currencyCode = CurrencyCodes(context: context)
            currencyCode.code = code
            
        }
        
        PersistenceController.shared.save()
    }
    
    
    func fetchCachedCurrencyCodes() -> [CurrencyCodes]? {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<CurrencyCodes> = CurrencyCodes.fetchRequest()
        
        do {
            let currencyCodes = try context.fetch(fetchRequest)
            return currencyCodes
        } catch {
            print("Error fetching currency codes: \(error)")
            return nil
        }
    }
    
    
    
    func saveExchangeRatesToCoreData(baseCurrency: String, rates: [String: Double]) {
        let context = PersistenceController.shared.container.viewContext
        
        // Removing old data for the selected base currency
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "baseCurrency == %@", baseCurrency)
        
        do {
            let existingRates = try context.fetch(fetchRequest)
            for rate in existingRates {
                context.delete(rate)
            }
        } catch {
            print("Error fetching existing rates: \(error)")
        }
        
        // Saving new rates
        for (currency, rateValue) in rates {
            let exchangeRate = ExchangeRate(context: context)
            exchangeRate.baseCurrency = baseCurrency
            exchangeRate.exchangeCurrencyCode = currency
            exchangeRate.exchangeRate = rateValue
            exchangeRate.timeStamp = Date()
        }
        
        PersistenceController.shared.save()
    }
    
    
    func fetchCachedExchangeRates(for baseCurrency: String) -> [ExchangeRate]? {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "baseCurrency == %@", baseCurrency)
        
        do {
            let rates = try context.fetch(fetchRequest)
            //return rates.count > 0 ? rates : nil
            return rates
        } catch {
            print("Error fetching rates for \(baseCurrency): \(error)")
            return nil
        }
    }
    
}
