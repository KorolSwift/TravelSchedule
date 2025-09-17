//
//  RoutesViewModel.swift
//  TravelSchedule
//
//  Created by Ди Di on 17/09/25.
//

import SwiftUI
import OpenAPIURLSession


@Observable
final class RoutesViewModel {
    var path = NavigationPath()
    var selectedStationFrom: String = ""
    var selectedStationTo: String = ""
    var allRoutes: [Segment] = []
    var filteredRoutes: [Segment] = []
    var selectedTimes: Set<String> = []
    var selectedTransfer: String = ""
    var shouldResetOnAppear = false
    
    var hasActiveFilters: Bool {
        filteredRoutes.count != allRoutes.count
    }
    
    var canSearch: Bool {
        !selectedStationFrom.isEmpty && !selectedStationTo.isEmpty
    }
    
    func swapStations() {
        swap(&selectedStationFrom, &selectedStationTo)
    }
    
    func handleOnAppear() {
        if allRoutes.isEmpty, let search = loadMockSearch() {
            allRoutes = search.segments
            filteredRoutes = search.segments
        }
        if shouldResetOnAppear {
            filteredRoutes = allRoutes
            shouldResetOnAppear = false
        }
    }
    
    func applyFilters() {
        filteredRoutes = allRoutes.filter { route in
            matchesTimeFilter(route.departure) && matchesTransferFilter(route)
        }
    }
    
    func matchesTimeFilter(_ departure: String) -> Bool {
        guard !selectedTimes.isEmpty else { return true }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withTimeZone]
        guard let date = formatter.date(from: departure) else { return false }
        let hour = Calendar.current.component(.hour, from: date)
        
        return selectedTimes.contains { timeRange in
            switch timeRange {
            case "Утро 06:00 - 12:00": return (6..<12).contains(hour)
            case "День 12:00 - 18:00": return (12..<18).contains(hour)
            case "Вечер 18:00 - 00:00": return (18..<24).contains(hour)
            case "Ночь 00:00 - 06:00": return (0..<6).contains(hour)
            default: return false
            }
        }
    }
    
    func matchesTransferFilter(_ route: Segment) -> Bool {
        switch selectedTransfer.trimmingCharacters(in: .whitespacesAndNewlines) {
        case "Да":  return route.has_transfers
        case "Нет": return !route.has_transfers
        default:    return true
        }
    }
    
    func loadMockSearch() -> Search? {
        guard let url = Bundle.main.url(forResource: "search", withExtension: "json") else {
            print("Не найден файл search.json")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Search.self, from: data)
        } catch {
            print("Ошибка парсинга JSON: \(error)")
            return nil
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
