//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import Foundation
import CoreData
import Combine
import UserNotifications
import SwiftUICore

class TimerViewModel: ObservableObject {
    @Published var timerSubscription: Cancellable?
    @Published var remainingTime: Int = 0
    @Published var inputMinutes: String = "1"
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var sessionCount: Int = 0
    
    private var context: NSManagedObjectContext
    private let notificationService: NotificationService = NotificationService()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        getSessionCount()
    }
    
    private func getSessionCount() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        let calendar = Calendar.current
        let today = Date()
        
        let startOfDay = calendar.startOfDay(for: today)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let sessions = try context.fetch(request)
            sessionCount = sessions.count
        } catch {
            print("Error fetching todos: \(error)")
        }
    }
    
    private func startTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    let newSession = Session(context: self.context)
                    newSession.id = UUID()
                    newSession.date = Date()
                    newSession.duration = Int16(self.inputMinutes) ?? 30
                    
                    self.saveContext()
                    self.notificationService.sendNotification()
                    
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
    
    private func saveContext() {
        do {
            try context.save()
            getSessionCount()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
}
