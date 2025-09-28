//
//  SearchBar.swift
//  SwiftUIProject
//
//

import SwiftUI


struct SearchBar: View {
    @Binding var searchText: String
    @State private var isEditing = false
    var placeholder = Constants.Texts.enterQuery
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $searchText, onEditingChanged: { editing in
                    isEditing = editing
                })
                .font(.regular17)
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
            .cornerRadius(Constants.Common.cornerRadius10)
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
