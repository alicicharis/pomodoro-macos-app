//
//  ContentView.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var timerSubscription: Cancellable?
    @State private var remainingTime: Int = 0
    @State private var inputMinutes: String = "1" // Default to 1 minute
    @State private var isRunning: Bool = false
    @State private var isPaused: Bool = false
    
    var body: some View {
        VStack {
            if !isRunning && !isPaused {
                TextField("Enter minutes", text: $inputMinutes)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Text("\(timeString(from: remainingTime))")
                .font(.largeTitle)
                .padding()
            
            if !isRunning && !isPaused {
                Button(action: startCountdown) {
                    Text("Start Timer")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(inputMinutes.isEmpty)
            } else if isRunning {
                Button(action: pauseCountdown) {
                    Text("Pause Timer")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else if isPaused {
                Button(action: resumeCountdown) {
                    Text("Resume Timer")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    private func startCountdown() {
        guard !isRunning else { return }
        
        if let minutes = Int(inputMinutes), minutes > 0 {
            remainingTime = minutes * 60
            isRunning = true
            startTimer()
        }
    }
    
    private func startTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timerSubscription?.cancel()
                    isRunning = false
                    isPaused = false
                }
            }
    }
    
    private func pauseCountdown() {
        timerSubscription?.cancel()
        isRunning = false
        isPaused = true
    }
    
    private func resumeCountdown() {
        isRunning = true
        isPaused = false
        startTimer()
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
        .frame(width: 250, height: 250)
}
