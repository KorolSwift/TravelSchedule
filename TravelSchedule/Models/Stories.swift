//
//  Stories.swift
//  TravelSchedule
//
//  Created by Ди Di on 26/09/25.
//

import SwiftUI


struct StoryGroup {
    let images: [String]
}

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(.close)
        }
    }
}

struct StoryTextOverlay: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Constants.Common.spacing16) {
                Text(title)
                    .font(.bold34)
                    .foregroundColor(.ypWhite)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text(subtitle)
                    .font(.regular20)
                    .foregroundColor(.ypWhite)
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct StoryPreview: View {
    let group: StoryGroup
    let title: String
    let action: () -> Void
    let isViewed: Bool
    
    var body: some View {
        VStack {
            if let firstImage = group.images.first {
                ZStack {
                    Image(firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.Story.previewWidth, height: Constants.Story.previewHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Common.cornerRadius16)
                                .stroke(isViewed ? Color.clear : Color.ypBlue, lineWidth: 4)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Common.cornerRadius16))
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(title)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.ypWhite)
                            .lineLimit(3)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 12)
                    }
                }
                .frame(width: Constants.Story.previewWidth, height: Constants.Story.previewHeight)
                .opacity(isViewed ? 0.5 : 1.0)
            }
        }
        .onTapGesture {
            action()
        }
    }
}
