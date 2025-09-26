//
//  CarrierInfoView.swift
//  TravelSchedule
//
//  Created by Ди Di on 09/09/25.
//

import SwiftUI


struct CarrierInfoView: View {
    @Binding var showDivider: Bool
    let route: CarrierInfo
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                CarrierImageView()
                CarrierTitleView(title: route.carrier.title)
                CarrierContactInfoView(email: route.carrier.email, phone: route.carrier.phone)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .navigationTitle("Информация о перевозчике")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { showDivider = false }
    }
    
    // MARK: - Subviews
    private struct CarrierImageView: View {
        var body: some View {
            Image(.carrierInfo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
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
            VStack(alignment: .leading, spacing: 0) {
                if let email, !email.isEmpty {
                    ContactRow(label: "E-mail", value: email)
                }
                if let phone, !phone.isEmpty {
                    ContactRow(label: "Телефон", value: phone)
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
            .frame(height: 60)
        }
    }
}


#Preview {
    CarrierInfoView(
        showDivider: .constant(true),
        route: CarrierInfo(
            carrier: CarrierDetails(
                code: 123,
                logo: nil,
                title: "Uzbekistan Airways",
                email: "info@uzairways.com",
                phone: "+998 71 200-00-00"
            )
        )
    )
}
