//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var timerSubscription: Cancellable?
    @Published var remainingTime: Int = 0
    @Published var inputMinutes: String = "1"
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    
    private func startTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    self.timerSubscription?.cancel()
                    self.isRunning = false
                    self.isPaused = false
                }
            }
    }
    
    func startCountdown() {
        guard !isRunning else { return }
        
        if let minutes = Int(inputMinutes), minutes > 0 {
            remainingTime = minutes * 60
            isRunning = true
            startTimer()
        }
    }
    
    func pauseCountdown() {
        timerSubscription?.cancel()
        isRunning = false
        isPaused = true
    }
    
    func resumeCountdown() {
        isRunning = true
        isPaused = false
        startTimer()
    }
    
    func cancelCountdown() {
        isRunning = false
        isPaused = false
        timerSubscription?.cancel()
        timerSubscription = nil
        remainingTime = 0
    }
    
    func timeString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
