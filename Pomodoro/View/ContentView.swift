//
//  ContentView.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack {
            if !timerViewModel.isRunning && !timerViewModel.isPaused {
                TextField("", text: $timerViewModel.inputMinutes)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 75)
            }
            
            Text("\(timerViewModel.timeString(timerViewModel.remainingTime))")
                .font(.largeTitle)
                .padding()
            
            if !timerViewModel.isRunning && !timerViewModel.isPaused {
                ButtonView(buttonText: "Start", buttonColor: Color.blue, disabled: timerViewModel.inputMinutes.isEmpty, buttonAction: timerViewModel.startCountdown)
            } else if timerViewModel.isRunning {
                ButtonView(buttonText: "Pause", buttonColor: Color.orange, disabled: false, buttonAction: timerViewModel.pauseCountdown)
            } else if timerViewModel.isPaused {
                VStack {
                    ButtonView(buttonText: "Resume", buttonColor: Color.green, disabled: false, buttonAction: timerViewModel.resumeCountdown)
                    
                    ButtonView(buttonText: "Cancel", buttonColor: Color.red, disabled: false, buttonAction: timerViewModel.cancelCountdown)
                }
            }
            Spacer()
            Text("Sessions: \(timerViewModel.sessionCount)")
                .font(.system(size: 18, weight: .regular, design: .default))
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView(timerViewModel: TimerViewModel(context: DataController.shared.viewContext))
        .frame(width: 300, height: 300)
}
