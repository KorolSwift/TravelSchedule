//
//  SearchBar.swift
//  SwiftUIProject
//
//

import SwiftUI


struct SearchBar: View {
    @Binding var searchText: String
    @State private var isEditing = false
    var placeholder = "Введите запрос"
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $searchText, onEditingChanged: { editing in
                    isEditing = editing
                })
                .font(Font(UIFont.sfProDisplayRegular17 ?? .systemFont(ofSize: 17, weight: .regular)))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchBar(searchText: .constant("Москва"))
}
