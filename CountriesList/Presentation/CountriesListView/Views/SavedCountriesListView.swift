//
//  SavedCountriesListView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import SwiftUI

struct SavedCountriesListView: View {
    @Binding var savedCountries: [Country]
    let onRemove: (Country) -> Void
    let onNavigate: (Country) -> Void
    let onAddFavorite: (Country) -> Void
    
    var body: some View {
            List {
                ForEach($savedCountries) { country in
                    SavedCountryRowView(
                        country: country,
                        onNavigate: onNavigate,
                        onAddFavorite: onAddFavorite
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            onRemove(country.wrappedValue)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
    }
}

#Preview {
    // Sample countries for preview
    let sampleCountries = [
        Country(id: "EG", name: "Egypt", capital: "Cairo", flag: "🇪🇬", currencies: nil),
        Country(id: "US", name: "United States", capital: "Washington D.C.", flag: "🇺🇸", currencies: nil),
        Country(id: "FR", name: "France", capital: "Paris", flag: "🇫🇷", currencies: nil)
    ]
    
    SavedCountriesListView(
        savedCountries: .constant(sampleCountries)  ,
        onRemove: { country in },
        onNavigate: { country in },
        onAddFavorite: { country in }
    )
}
