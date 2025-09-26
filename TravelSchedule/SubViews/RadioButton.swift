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
        VStack(alignment: .leading, spacing: 12) {
            ForEach(transferOptions, id: \.self) { option in
                HStack {
                    Text(option)
                        .frame(height: 60)
                        .onTapGesture {
                            selectedTransfer = option
                        }
                    Spacer()
                    
                    Image(systemName: selectedTransfer == option ? "largecircle.fill.circle" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            selectedTransfer = option
                        }
                        .padding(.trailing, 18)
                }
                .foregroundColor(.primary)
                .frame(height: 60)
            }
        }
        .padding()
    }
}


#Preview {
    @State var selected = "Нет"
    
    return RadioButton(
        selectedTransfer: $selected,
        transferOptions: ["Да", "Нет"]
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
