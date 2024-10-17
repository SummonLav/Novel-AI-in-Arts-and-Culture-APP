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
    @State private var showOptions = false // State to control options visibility
    
    var body: some View {
        ZStack {
            // BG
            Color.black.ignoresSafeArea()
            
            // Avatar Content
            VStack {
                // AI Chatbot
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
                
                Spacer()
                
                // Character Image (No Animation Triggered on Option Appearance)
                avatarPhoto
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400) // Static frame dimensions
                    .cornerRadius(20)
                
                Spacer()
                
                // Recommendations Appear Animation
                if showOptions {
                    VStack {
                        HStack {
                            Text("Ticket to Wallet")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                            
                            Text("About the Event")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        HStack {
                            Text("Personal Settings")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                            
                            Text("More ...")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .foregroundStyle(.white)
                    .transition(.opacity) // Add a transition for smooth appearance
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // User Interaction
                HStack {
                    // Voice Button
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "microphone.fill")
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Text Input
                    Text("Ask me anything ...")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.gray.opacity(0.2).cornerRadius(8))
                    
                    Spacer()
                    
                    // Submit Button
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        showOptions = true
                    }
                }
            }
        }
    }
}

#Preview {
    AIChatbotView()
}
