//
//  currencyConverterApp.swift
//  currencyConverter
//
//  Created by Anjali Pandey on 31/01/25.
//

import SwiftUI

@main
struct currencyConverterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        WindowGroup {
            CurrencyConverterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
