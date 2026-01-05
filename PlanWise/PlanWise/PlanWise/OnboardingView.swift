//
//  OnboardingView.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var name: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Welcome to PlanWise")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.headline)
                        
                        TextField("Enter your name", text: $name)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Birth")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.headline)
                        
                        DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .colorScheme(.dark)
                    }
                }
                .padding(.horizontal)
                
                Button(action: submitOnboarding) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPurple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .padding()
        }
        .alert("Please enter your name", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func submitOnboarding() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert = true
            return
        }
        
        userManager.completeOnboarding(name: name, dob: dateOfBirth)
    }
}
