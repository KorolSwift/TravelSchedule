//
//  CitiesView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct CitiesView: View {
    let title: String
    let cities: [String]
    @Binding var showDivider: Bool
    @State private var searchString = ""
    @Binding var selectedStation: String
    let isFrom: Bool
    @Binding var path: NavigationPath
    
    var searchCities: [String] {
        if searchString.isEmpty {
            return cities
        } else {
            return cities.filter {
                $0.localizedCaseInsensitiveContains(searchString)
            }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchString)
            if searchCities.isEmpty {
                VStack {
                    Spacer()
                    Text("Город не найден")
                        .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                    Spacer()
                }
            } else {
                List {
                    ForEach(searchCities, id: \.self) { city in
                        NavigationLink(value: Nav.stations(city: city, isFrom: isFrom)) {
                            Text(city)
                        }
                        .font(Font(UIFont.sfProDisplayRegular17 ?? .systemFont(ofSize: 17, weight: .regular)))
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .background(Color(.systemBackground))
                .scrollContentBackground(.hidden)
                .listRowBackground(Color(.systemBackground))
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Выбор города")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            showDivider = false
//            showServerError("500 Internal Server Error")
        }
    }
}

#Preview {
    @State var showDivider = true
    @State var selectedStation = ""
    @State var path = NavigationPath()
    
    return NavigationStack(path: $path) {
        CitiesView(
            title: "Откуда",
            cities: ["Москва", "Сочи", "Казань"],
            showDivider: $showDivider,
            selectedStation: $selectedStation,
            isFrom: true,
            path: $path
        )
    }
}
