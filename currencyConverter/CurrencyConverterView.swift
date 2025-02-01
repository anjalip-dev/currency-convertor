//
//  CurrencyConverterView.swift
//  currencyConverter
//
//  Created by Anjali Pandey on 31/01/25.
//

import SwiftUI
import CoreData


struct CurrencyConverterView: View {
    
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @FocusState private var isAmountFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Currency Converter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 550)
                
                VStack(spacing: 20) {
                    
                    VStack {
                        
                        TextField("Enter amount", text: $viewModel.amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                            .cornerRadius(5)
                            .focused($isAmountFieldFocused)
                            .padding()
                        
                       
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .opacity(viewModel.isLoading ? 1 : 0)
                                .padding()
                        } else {
                            Text("=")
                                .font(.title)
                        }
                        
                        
                        TextField("Converted Amount", text: $viewModel.convertedAmount)
                            .font(.title2)
                            .disabled(true)
                            .opacity(0.9)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .fontWeight(.medium)
                            .padding()
                        
                    }
                    
                    
                    HStack {
                        VStack {
                            Text("From")
                            Picker("From", selection: $viewModel.fromCurrency) {
                                ForEach(viewModel.currencies, id: \.self) { currency in
                                    Text(currency)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        Spacer()
                        
                        Button(action: viewModel.swapCurrencies) {
                            Image(systemName: "arrow.swap")
                                .font(.title)
                                .foregroundColor(.blue)
                                .frame(width: 16, height: 16)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(radius: 1)
                        }
                        .padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("To")
                            Picker("To", selection: $viewModel.toCurrency) {
                                ForEach(viewModel.currencies, id: \.self) { currency in
                                    Text(currency)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                    }
                    .padding()
                    
                    
                    Button(action: { isAmountFieldFocused = false
                        viewModel.convertCurrency()}) {
                        Text("Convert")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isLoading ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .disabled(viewModel.isLoading)
                    .padding()
                  
                    
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    CurrencyConverterView()
}

