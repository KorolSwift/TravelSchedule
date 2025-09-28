//
//  Checkbox.swift
//  TravelSchedule
//
//  Created by Ди Di on 11/09/25.
//

import SwiftUI


struct Checkbox: View {
    @Binding var selectedOptions: Set<String>
    let options: [String]
    
    var body: some View {
        VStack(spacing: Constants.Common.spacing0) {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                        .frame(height: Constants.Common.height60)
                        .onTapGesture {
                            toggle(option)
                        }
                    Spacer()
                    
                    Image(systemName: selectedOptions.contains(option) ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: Constants.Common.checkmarkSize, height: Constants.Common.checkmarkSize)
                        .foregroundColor(selectedOptions.contains(option) ? .primary : .secondary)
                        .onTapGesture {
                            toggle(option)
                        }
                        .padding(.trailing, 18)
                }
                .foregroundColor(.primary)
            }
        }
        .padding()
    }
    
    func toggle(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}


#Preview {
    @State var selected: Set<String> = ["Утро 06:00 - 12:00"]
    
    return Checkbox(
        selectedOptions: $selected,
        options: ["Утро 06:00 - 12:00", "День 12:00 - 18:00", "Вечер 18:00 - 00:00", "Ночь 00:00 - 06:00"]
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
