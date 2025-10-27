//
//  CarrierInfoView.swift
//  TravelSchedule
//
//  Created by Ди Di on 09/09/25.
//

import SwiftUI


@MainActor
struct CarrierInfoView: View {
    @Binding var showDivider: Bool
    let route: Segment
    
    @State private var carrierInfo: Components.Schemas.CarrierInfo?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
            } else if let info = carrierInfo {
                VStack(alignment: .leading, spacing: Constants.Common.spacing16) {
                    CarrierImageView(logo: info.carrier?.logo)
                    
                    if let carrier = info.carrier {
                        CarrierTitleView(title: carrier.title ?? "Без названия")
                        CarrierContactInfoView(email: carrier.email, phone: carrier.phone)
                    }
                }
                .padding([.top, .horizontal], 16)
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle(Constants.Texts.carrInfo)
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            showDivider = false
            Task { await loadCarrierInfo() }
        }
    }
    
    // MARK: - Subviews
    private struct CarrierImageView: View {
        let logo: String?
        
        var body: some View {
            if let logo, let url = URL(string: logo) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    case .failure:
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    private struct CarrierTitleView: View {
        let title: String
        
        var body: some View {
            Text(title)
                .font(.bold24)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundColor(.primary)
        }
    }
    
    private struct CarrierContactInfoView: View {
        let email: String?
        let phone: String?
        
        var body: some View {
            VStack(alignment: .leading, spacing: Constants.Common.spacing0) {
                if let email = email, email.isEmpty == false {
                    ContactRow(label: Constants.Texts.contactEmail, value: email)
                }
                if let phone = phone, phone.isEmpty == false {
                    ContactRow(label: Constants.Texts.contactPhone, value: phone)
                }
            }
        }
    }
    
    private struct ContactRow: View {
        let label: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.regular17)
                    .foregroundColor(.primary)
                Text(value)
                    .font(.regular12)
                    .foregroundColor(.ypBlue)
            }
            .frame(height: Constants.Common.height60)
        }
    }
    
    private func loadCarrierInfo() async {
        guard let code = route.thread.carrier.codes?.iata else {
            errorMessage = "Нет кода перевозчика (IATA)"
            isLoading = false
            return
        }
        do {
            async let info = NetworkClient.shared.fetchCarrierInformation(code: code, system: "iata")
            carrierInfo = try await info
        } catch {
            errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
        }
        isLoading = false
    }
}


#Preview {
    let mockCarrier = Carrier(
        title: "Uzbekistan Airways",
        code: 123,
        codes: Carrier.CarrierCodes(iata: "HY", sirena: nil, icao: "UZB"),
        logo: nil,
        logoSvg: nil
    )
    let mockThread = Thread(uid: "HY001", carrier: mockCarrier)
    let mockSegment = Segment(
        thread: mockThread,
        startDate: Date(),
        departure: Date(),
        arrival: Date().addingTimeInterval(7200),
        duration: 7200,
        hasTransfers: false
    )
    return CarrierInfoView(
        showDivider: .constant(false),
        route: mockSegment
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
