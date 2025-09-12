//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Ди Di on 22/08/25.
//

import SwiftUI
import CoreData
import OpenAPIURLSession
import UIKit


struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var selectedStationFrom = ""
    @State private var selectedStationTo = ""
    @State private var allRoutes: [Segment] = []
    @State private var filteredRoutes: [Segment] = []
    @Binding var showDivider: Bool
    @State private var resetRoutesOnNextCarriersAppear = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.ypBlue)
                        .frame(height: 128)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.ypWhite)
                        .frame(height: 96)
                        .padding(.leading, 16)
                        .padding(.trailing, 68)
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            NavigationLink(value: Nav.citiesFrom) {
                                HStack {
                                    Text(selectedStationFrom.isEmpty ? "Откуда" : selectedStationFrom)
                                        .foregroundColor(selectedStationFrom.isEmpty ? .ypGray : .black)
                                        .font(Font(UIFont.sfProDisplayRegular17 ?? .systemFont(ofSize: 17, weight: .regular)))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                .frame(height: 48)
                                .padding(.horizontal, 16)
                            }
                            NavigationLink(value: Nav.citiesTo) {
                                HStack {
                                    Text(selectedStationTo.isEmpty ? "Куда" : selectedStationTo)
                                        .foregroundColor(selectedStationTo.isEmpty ? .ypGray : .black)
                                        .font(Font(UIFont.sfProDisplayRegular17 ?? .systemFont(ofSize: 17, weight: .regular)))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                .frame(height: 48)
                            }
                            .padding(.horizontal, 16)
                            .pickerStyle(.navigationLink)
                            .foregroundColor(.ypGray)
                        }
                        .padding(.leading, 16)
                        Spacer()
                        Button(action: {
                            swap(&selectedStationFrom, &selectedStationTo)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 36, height: 36)
                                Image(systemName: "arrow.2.squarepath")
                                    .foregroundColor(Color.ypBlue)
                            }
                        }
                        .padding(.trailing, 16)
                    }
                }
                .padding(16)
                if !selectedStationTo.isEmpty && !selectedStationFrom.isEmpty {
                    NavigationLink(value: Nav.carriers) {
                        ZONaiseek()
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        resetRoutesOnNextCarriersAppear = true
                    })
                    .onAppear {
                        showDivider = true
//                        showServerError("500 Internal Server Error")
                    }
                    //            testFetchStations()
                    //            testFetchNearestSettlement()
                    //            testFetchCarrierInformation()
                    //            testFetchScheduleBTWStations()
                    //            testFetchScheduleByStations()
                    //            testFetchStationsList()
                    //            testFetchCopyrightYandexSchedules()
                    //            testAvailableStationsList()
                }
            }
            .navigationDestination(for: Nav.self) { dest in
                switch dest {
                case .carriers:
                    CarriersListView(
                        selectedStationFrom: $selectedStationFrom,
                        selectedStationTo: $selectedStationTo,
                        allRoutes: $allRoutes,
                        filteredRoutes: $filteredRoutes,
                        navigationPath: $path,
                        showDivider: $showDivider,
                        shouldResetOnAppear: $resetRoutesOnNextCarriersAppear
                    )
                case .filtration:
                    FiltrationView(
                        allRoutes: $allRoutes,
                        filteredRoutes: $filteredRoutes,
                        showDivider: $showDivider
                    )
                case .segment(let seg):
                    CarrierInfoView(segment: seg, showDivider: $showDivider)
                case .citiesFrom:
                    CitiesView(
                        title: "Откуда",
                        cities: cities,
                        showDivider: $showDivider,
                        selectedStation: $selectedStationFrom,
                        isFrom: true,
                        path: $path
                    )
                case .citiesTo:
                    CitiesView(
                        title: "Куда",
                        cities: cities,
                        showDivider: $showDivider,
                        selectedStation: $selectedStationTo,
                        isFrom: false,
                        path: $path
                    )
                case .stations(let city, let isFrom):
                    StationsView(
                        city: city,
                        showDivider: $showDivider,
                        selectedStation: isFrom ? $selectedStationFrom : $selectedStationTo,
                        path: $path
                    )
                }
            }
        }
    }
    @ViewBuilder
    private func ZONaiseek() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ypBlue)
                .frame(width: 150, height: 60)
            Text("Найти")
                .foregroundColor(.ypWhite)
                .font(UIFont.sfProDisplayBold17 != nil ? Font(UIFont.sfProDisplayBold17!) : .system(size: 17, weight: .bold))
        }
    }
    
    func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestStationsService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                
                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
    
    func testFetchNearestSettlement() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestSettlementService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching nearest settlement...")
                let settlement = try await service.getNearestSettlement(
                    lat: 50.440046,
                    lng: 40.4882367,
                    distance: 50
                )
                
                print("Successfully fetched settlement: \(settlement)")
            } catch {
                print("Error fetching settlement: \(error)")
            }
        }
    }
    
    func testFetchCarrierInformation() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CarrierInformationService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching carrier information...")
                let information = try await service.getCarrierInformation(
                    code: "TK",
                    system: "iata"
                )
                
                print("Successfully fetched carrier information: \(information)")
            } catch {
                print("Error fetching carrier information: \(error)")
            }
        }
    }
    
    func testFetchScheduleBTWStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleBTWStationsService(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching schedule between stations...")
                let scheduleBTW = try await service.getScheduleBTWStations(
                    from: "c146",
                    to: "c213",
                    date: "2025-09-02"
                )
                
                print("Successfully fetched schedule between stations: \(scheduleBTW)")
            } catch {
                print("Error fetching schedule between stations \(error)")
            }
        }
    }
    
    func testFetchScheduleByStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleByStationsServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching schedule by stations...")
                let scheduleByStations = try await service.getScheduleByStations(
                    station: "s9600213"
                )
                
                print("Successfully fetched schedule by stations: \(scheduleByStations)")
            } catch {
                print("Error fetching schedule by stations \(error)")
            }
        }
    }
    
    func testFetchStationsList() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = StationsListServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching list of stations...")
                let stationsList = try await service.getStationsList(
                    uid: "098S_7_2"
                )
                
                print("Successfully fetched list of stations \(stationsList)")
            } catch {
                print("Error fetching list of stations \(error)")
            }
        }
    }
    
    func testFetchCopyrightYandexSchedules() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CopyrightYandexSchedulesServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching copyright yandex schedules..")
                let copyright = try await service.getCopyrightYandexSchedules(
                    format: "json"
                )
                
                print("Successfully fetched copyright yandex schedules \(copyright)")
            } catch {
                print("Error fetching copyright yandex schedules \(error)")
            }
        }
    }
    
    func testAvailableStationsList() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = AvailableStationsListServices(
                    client: client,
                    apikey: ApiKeyProvider.shared.value
                )
                
                print("Fetching available stations list..")
                let availableStations = try await service.getAvailableStationsList()
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let data = try encoder.encode(availableStations)
                let fileManager = FileManager.default
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent("AvailableStationsList.json")
                try data.write(to: fileURL)
                
                print("Successfully saved stations list to file:")
                print(fileURL.path)
                
            } catch {
                print("Error fetching available stations list \(error)")
            }
        }
    }
}

#Preview {
    @State  var showDivider = true
    ContentView(showDivider: $showDivider)
}
