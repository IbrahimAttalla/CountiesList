//
//  SavedCountryRowView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import SwiftUI

struct SavedCountryRowView: View {
    @Binding var country: Country
    let onNavigate: (Country) -> Void
    let onAddFavorite: (Country) -> Void
    
    var body: some View {
        HStack {
            if let flag = country.flag {
                Text(flag)
                    .font(.system(size: 50))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let capital = country.capital {
                    Text("Capital: \(capital)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let currencies = country.currencies, !currencies.isEmpty {
                    let currencyDisplay = currencies.map { "\($0.symbol) \($0.code)" }.joined(separator: ", ")
                    Text("Currency: \(currencyDisplay)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if country.isFavorite {
                Text("Added")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(.gray)
                    .cornerRadius(3)
                
            } else {
                Button(action: { onAddFavorite(country) }) {
                    Image(systemName: "plus.square.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .scaleEffect(1.2)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Button(action: { onNavigate(country) }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 20, weight: .semibold))
            }
            
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let sampleCountry = Country(
        id: "EG",
        name: "Egypt",
        capital: "Cairo",
        flag: "🇪🇬",
        currencies: [
            Country.Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")
        ]
    )
    
    SavedCountryRowView(
        country: .constant(sampleCountry) ,
        onNavigate: { country in },
        onAddFavorite: { country in }
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
