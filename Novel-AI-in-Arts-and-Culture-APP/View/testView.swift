//
//  testView.swift
//  Novel-AI-in-Arts-and-Culture-APP
//
//  Created by Lavenda Shan on 10/25/24.
//


import SwiftUI

struct testView: View {
    
    let avatarPhoto = Image("Van-Gogh")
    let QText: String = "Ahh, what kind of thoughts are swirling in your mind at this very moment?"
    @State private var isRecmd = false
    @State private var showOptions = false
    @State private var isFlipped = false
    @State private var showQText = false
    @State private var recommendations = ["Ticket to Wallet", "About the Event", "Personal Settings", "Invite a Friend"]
    @State private var newRecommendations = ["Save to Calendar", "Event Location", "Account Settings", "Help"]
    
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
                
                // Recommendations Appear Animation
                if showOptions {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            optionText(recommendations[0], newRecommendations[0])
                            optionText(recommendations[1], newRecommendations[1])
                        }
                        HStack(spacing: 15) {
                            optionText(recommendations[2], newRecommendations[2])
                            optionText(recommendations[3], newRecommendations[3])
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        showOptions = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func optionText(_ frontText: String, _ backText: String) -> some View {
        ZStack {
            // Back view (visible when flipped)
            Text(backText)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.warmYellow)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 1, y: 0, z: 0)
                )
            
            // Front view
            Text(frontText)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.warmYellow)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .opacity(isFlipped ? 0 : 1)
        }
        .frame(height: 45)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped.toggle()
            }
        }
    }
}

#Preview {
    testView()
}
