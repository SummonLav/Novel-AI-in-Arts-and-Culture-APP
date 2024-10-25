//
//  AIChatbotView.swift
//  Bloomberg-Connects-reDesign
//
//  Created by Lavenda Shan on 9/29/24.
//

import SwiftUI

struct AIChatbotView: View {
    
    let avatarPhoto = Image("Van-Gogh")
    let QText: String = "Ahh, what kind of thoughts are swirling in your mind at this very moment?"
    @State private var isRecmd = false
    @State private var showOptions = false
    @State private var showQText = false
    @State private var allRecommendations = [
        ["Ticket to Wallet", "About the Event", "Personal Settings", "Invite a Friend"],
        ["Save to Calendar", "Event Location", "Account Settings", "Help"],
        ["Audio Guide", "Share Experience", "Museum Map", "Gift Shop"],
        ["Rate Visit", "Leave Feedback", "Contact Us", "FAQ"]
    ]
    @State private var currentMatrixIndex = 0
    
    // Timer for matrix switching
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var currentMatrix: [[String]] {
        let index = currentMatrixIndex % allRecommendations.count
        let nextIndex = (currentMatrixIndex + 1) % allRecommendations.count
        return [
            allRecommendations[index],
            allRecommendations[nextIndex]
        ]
    }
    
    var body: some View {
        ZStack {
            // BG
            Color.black.ignoresSafeArea()
            
            // Avatar Content
            VStack {
                // AI Chatbot - Now conditional
                if showQText {
                    HStack(alignment: .top) {
                        avatarPhoto
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        
                        Text(QText)
                            .foregroundStyle(.white)
                            .padding(10.0)
                            .frame(maxWidth: 280)
                            .background(Color.gray.opacity(0.2).cornerRadius(20))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
                
                // Character Image with tap gesture
                avatarPhoto
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .cornerRadius(20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showQText.toggle()
                        }
                    }
                
                Spacer()
                
                // Floating Recommendations Matrix
                if showOptions {
                    VStack(spacing: 15) {
                        ForEach(0..<2) { row in
                            HStack(spacing: 15) {
                                ForEach(0..<2) { col in
                                    Text(currentMatrix[row][col])
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.warmYellow)
                                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                        )
                                }
                            }
                        }
                    }
                    .transition(.opacity)
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // User Interaction
                HStack {
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "microphone.fill")
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("Ask me anything ...")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.gray.opacity(0.2).cornerRadius(8))
                    
                    Spacer()
                    
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "paperplane")
                            .padding()
                    }
                }
                .font(.title2)
                .foregroundStyle(.white)
                .padding()
            }
            .onAppear {
                // Show options after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        showOptions = true
                    }
                }
            }
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 1)) {
                    currentMatrixIndex = (currentMatrixIndex + 1) % allRecommendations.count
                }
            }
        }
    }
}

#Preview {
    AIChatbotView()
}
