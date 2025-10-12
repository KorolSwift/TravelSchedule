//
//  RadioButton.swift
//  TravelSchedule
//
//  Created by Ди Di on 11/09/25.
//

import SwiftUI


struct RadioButton: View {
    @Binding var selectedTransfer: String
    let transferOptions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Common.spacing12) {
            ForEach(transferOptions, id: \.self) { option in
                HStack {
                    Text(option)
                        .frame(height: Constants.Common.height60)
                        .onTapGesture {
                            selectedTransfer = option
                        }
                    Spacer()
                    
                    Image(systemName: selectedTransfer == option ? "largecircle.fill.circle" : "circle")
                        .resizable()
                        .frame(width: Constants.Common.radioButtonSize, height: Constants.Common.radioButtonSize)
                        .onTapGesture {
                            selectedTransfer = option
                        }
                        .padding(.trailing, 18)
                }
                .foregroundColor(.primary)
                .frame(height: Constants.Common.height60)
            }
        }
        .padding()
    }
}


#Preview {
    StatefulPreviewWrapper("Нет") { selected in
        RadioButton(
            selectedTransfer: selected,
            transferOptions: ["Да", "Нет"]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
