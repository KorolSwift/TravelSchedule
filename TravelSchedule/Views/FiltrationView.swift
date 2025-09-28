//
//  FiltrationView.swift
//  TravelSchedule
//
//  Created by Ди Di on 08/09/25.
//

import SwiftUI


struct FiltrationView: View {
    @Bindable var viewModel: RoutesViewModel
    @Binding var showDivider: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            timeSection
            transferSection
            Spacer()
            if !viewModel.selectedTimes.isEmpty && !viewModel.selectedTransfer.isEmpty {
                applyButton
            }
        }
        .onAppear {
            showDivider = false
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarRole(.editor)
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: Constants.Common.spacing16) {
            Text(Constants.Texts.departureTime)
                .font(.bold24)
                .padding(.horizontal, 16)
            Checkbox(
                selectedOptions: $viewModel.selectedTimes,
                options: FilterTimeRange.allOptions
            )
        }
    }
    
    private var transferSection: some View {
        VStack(alignment: .leading, spacing: Constants.Common.spacing16) {
            Text(Constants.Texts.withTransfer)
                .font(.bold24)
                .padding(.horizontal, 16)
            RadioButton(
                selectedTransfer: $viewModel.selectedTransfer,
                transferOptions: ["Да", "Нет"]
            )
        }
    }
    
    private var applyButton: some View {
        Button {
            viewModel.applyFilters()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dismiss()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Common.cornerRadius24)
                    .fill(Color.ypBlue)
                    .frame(height: Constants.Common.height60)
                Text(Constants.Buttons.apply)
                    .foregroundColor(.ypWhite)
                    .padding()
            }
            .padding(.horizontal, 16)
        }
    }
}


#Preview {
    PreviewWrapper(viewModel: RoutesViewModel())
}
private struct PreviewWrapper: View {
    @State private var showDivider = true
    @Bindable var viewModel: RoutesViewModel
    
    var body: some View {
        FiltrationView(
            viewModel: viewModel,
            showDivider: $showDivider
        )
    }
}
