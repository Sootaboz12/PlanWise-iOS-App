//
//  UserManager.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//

import Foundation
import SwiftUI
import Combine

class UserManager: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("userName") var userName: String = ""
    @AppStorage("dateOfBirthTimestamp") private var dateOfBirthTimestamp: Double = Date().timeIntervalSince1970
    @AppStorage("mostRecentNoteIdString") private var mostRecentNoteIdString: String = ""
    
    // Computed property for dateOfBirth to convert between Date and timestamp
    var dateOfBirth: Date {
        get {
            return Date(timeIntervalSince1970: dateOfBirthTimestamp)
        }
        set {
            dateOfBirthTimestamp = newValue.timeIntervalSince1970
        }
    }
    
    // Computed property for mostRecentNoteId to convert between UUID and String
    var mostRecentNoteId: UUID? {
        get {
            return mostRecentNoteIdString.isEmpty ? nil : UUID(uuidString: mostRecentNoteIdString)
        }
        set {
            mostRecentNoteIdString = newValue?.uuidString ?? ""
        }
    }
    
    func completeOnboarding(name: String, dob: Date) {
        self.userName = name
        self.dateOfBirth = dob
        self.hasCompletedOnboarding = true
        
        // No need to manually save to UserDefaults - @AppStorage handles it automatically
    }
    
    func openNote(_ noteId: UUID) {
        mostRecentNoteId = noteId
        // No need to manually save to UserDefaults - @AppStorage handles it automatically
    }
}
