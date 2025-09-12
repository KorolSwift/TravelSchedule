//
//  StationsView.swift
//  TravelSchedule
//
//  Created by Ди Di on 07/09/25.
//

import SwiftUI


struct StationsView: View {
    let city: String
    @State private var searchString = ""
    @Binding var showDivider: Bool
    @Binding var selectedStation: String
    var stationList: [String] { stations[city] ?? [] }
    @Binding var path: NavigationPath
    
    var searchStations: [String] {
        if searchString.isEmpty {
            return stationList
        } else {
            return stationList.filter {
                $0.localizedCaseInsensitiveContains(searchString)
            }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchString)
            if searchStations.isEmpty {
                VStack {
                    Spacer()
                    Text("Станция не найдена")
                        .font(Font(UIFont.sfProDisplayBold24 ?? .systemFont(ofSize: 24, weight: .bold)))
                    Spacer()
                }
            } else {
                List {
                    ForEach(searchStations, id: \.self) { station in
                        HStack {
                            Text(station)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedStation = "\(city) (\(station))"
                            withAnimation(.easeInOut(duration: 0.15)) {
                                path.removeLast(2)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .background(Color(.systemBackground))
                .scrollContentBackground(.hidden)
                .listRowBackground(Color(.systemBackground))
            }
        }
        .onAppear {
            showDivider = false
            showServerError("500 Internal Server Error")
        }
        .navigationTitle("Выбор станции")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
    }
}


#Preview {
    @State var showDivider = true
    @State var selectedStation = ""
    @State var path = NavigationPath()
    
    return NavigationStack(path: $path) {
        StationsView(
            city: "Москва",
            showDivider: $showDivider,
            selectedStation: $selectedStation,
            path: $path
        )
    }
}
