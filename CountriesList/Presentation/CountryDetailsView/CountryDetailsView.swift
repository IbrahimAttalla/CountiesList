//
//  CountryDetailsView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import SwiftUI

struct CountryDetailsView: View {
    let country: Country
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Flag and Name
                HStack {
                    if let flag = country.flag {
                        Text(flag)
                            .font(.system(size: 80))
                    }
                    Text(country.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
                
                Divider()
                
                // Capital City
                if let capital = country.capital {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Capital City")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(capital)
                            .font(.title2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // Currency
                if let currencies = country.currencies, !currencies.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Currency")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ForEach(currencies, id: \.code) { currency in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(currency.name)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(currency.code)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(6)
                                }
                                Text("Symbol: \(currency.symbol)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Currency")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("No currency information available")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(country.name)
    }
}

#Preview {
    CountryDetailsView(
        country: Country(
            id: "EG",
            name: "Egypt",
            capital: "Cairo",
            flag: "🇪🇬",
            currencies: [
                Country.Currency(code: "EGP", name: "Egyptian pound", symbol: "£")
            ]
        )
    )
}
