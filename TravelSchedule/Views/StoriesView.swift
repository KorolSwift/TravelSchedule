//
//  StoriesView.swift
//  TravelSchedule
//
//  Created by Ди Di on 23/09/25.
//

import SwiftUI
import Combine


struct StoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentGroupIndex: Int
    @State private var currentImageIndex = 0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    @Binding var viewedStories: Set<Int>
    private let storyGroups: [StoryGroup]
    private let configuration: Configuration
    private var numberOfSections: Int {
        storyGroups[currentGroupIndex].images.count
    }
    
    init(startGroupIndex: Int = 0, viewedStories: Binding<Set<Int>>) {
        self._viewedStories = viewedStories
        self.storyGroups = (1...6).map {
            index in StoryGroup(images: ["\(index)", "\(index).1"])
        }
        self.configuration = Configuration(secondsPerStory: 10)
        _timer = State(initialValue: Self.createTimer(configuration: configuration))
        _currentGroupIndex = State(initialValue: startGroupIndex)
    }
    
    struct Configuration {
        let timerTickInternal: TimeInterval
        let progressPerTick: CGFloat
        init(
            secondsPerStory: TimeInterval = 10,
            timerTickInternal: TimeInterval = 0.05
        ) {
            self.timerTickInternal = timerTickInternal
            self.progressPerTick = 1.0 / secondsPerStory * timerTickInternal
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            backgroundImage
            overlayControls
            StoryTextOverlay(title: StoryText.firstText,
                             subtitle: StoryText.secondText)
        }
        .onAppear {
            timer = Self.createTimer(configuration: configuration)
            cancellable = timer.connect()
        }
        .onDisappear { cancellable?.cancel() }
        .onReceive(timer) { _ in timerTick() }
        .onTapGesture { nextStory() }
        .gesture(swipeGesture)
    }
}

private extension StoriesView {
    var backgroundImage: some View {
        let currentGroup = storyGroups[currentGroupIndex]
        let currentImage = currentGroup.images[currentImageIndex]
        
        return Image(currentImage)
            .resizable()
            .ignoresSafeArea()
            .cornerRadius(40)
            .background(Color.black)
    }
    
    var overlayControls: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ProgressBar(
                numberOfSections: numberOfSections,
                progress: (CGFloat(currentImageIndex) + progress) / CGFloat(numberOfSections)
            )
            .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
            
            CloseButton { dismiss() }
                .padding(.trailing, 12)
        }
    }
    
    var swipeGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                let threshold = UIScreen.main.bounds.width * 0.2
                if value.translation.width < -threshold {
                    nextStory()
                    resetTimer()
                } else if value.translation.width > threshold {
                    previousStory()
                    resetTimer()
                }
            }
    }
}

private extension StoriesView {
    func timerTick() {
        progress += configuration.progressPerTick
        if progress >= 1.0 {
            progress = 0.0
            nextStory()
        }
    }
    
    func nextStory() {
        let currentGroup = storyGroups[currentGroupIndex]
        viewedStories.insert(currentGroupIndex)
        
        if currentImageIndex + 1 < currentGroup.images.count {
            currentImageIndex += 1
        } else {
            currentImageIndex = 0
            currentGroupIndex = (currentGroupIndex + 1) % storyGroups.count
        }
        progress = 0.0
        resetTimer()
    }
    
    func previousStory() {
        viewedStories.insert(currentGroupIndex)
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        } else {
            currentGroupIndex = currentGroupIndex > 0
            ? currentGroupIndex - 1
            : storyGroups.count - 1
            currentImageIndex = storyGroups[currentGroupIndex].images.count - 1
        }
        progress = 0.0
        resetTimer()
    }
    
    func resetTimer() {
        cancellable?.cancel()
        timer = Self.createTimer(configuration: configuration)
        cancellable = timer.connect()
        progress = 0.0
    }
    
    static func createTimer(configuration: Configuration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}


#Preview {
    StatefulPreviewWrapper(Set<Int>()) { viewedStories in
        StoriesView(startGroupIndex: 0, viewedStories: viewedStories)
    }
}
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content
    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    var body: some View {
        content($value)
    }
}
