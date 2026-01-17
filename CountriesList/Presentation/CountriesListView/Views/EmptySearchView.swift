//
//  EmptySearchView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 18/01/2026.
//

import SwiftUI

struct EmptySearchView: View {
    let onShowFavorites: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary)

            Text("No countries found")
                .font(.headline)

            Button("Show Favorites") {
                onShowFavorites()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
            Spacer()
        }
        .padding(.top, 80)
        
        
    }
}


#Preview {
    EmptySearchView {}
    .padding()
}
