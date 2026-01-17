//
//  SearchBarView.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @FocusState.Binding var isSearchFocused: Bool
    let onSearch: () -> Void
    let onClear: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search for a country...", text: $searchText)
                    .textFieldStyle(.plain)
                    .focused($isSearchFocused)
                    .onSubmit {
                        if !searchText.isEmpty {
                            onSearch()
                            searchText = ""
                            isSearchFocused = false
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: onClear) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Search Button
            Button(action: {
                guard !searchText.isEmpty else { return }
                onSearch()
                isSearchFocused = false
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(searchText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(searchText.isEmpty)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    // Temporary state for the preview
    @Previewable @State var searchText = "Egypt"
    @FocusState var isFocused: Bool

    return VStack {
        SearchBarView(
            searchText: $searchText,
            isSearchFocused: $isFocused,
            onSearch: {},
            onClear: {
                searchText = ""
            }
        )
        Spacer()
    }
    .previewLayout(.sizeThatFits)
}
