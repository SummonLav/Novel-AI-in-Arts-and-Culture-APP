//
//  ContentView.swift
//  Novel-AI-in-Arts-and-Culture-APP
//
//  Created by Lavenda Shan on 10/16/24.
//

import SwiftUI
import SDWebImageSwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    let openAI = OpenAI(apiToken: "")
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        // Convert local messages to OpenAI format
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
        
        // Send request to OpenAI
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                // Update UI on main thread
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}


struct ContentView: View {
    
    let avatarPhoto = Image("Van-Gogh-2")
    let gifUrl = Bundle.main.url(forResource: "Van-Gogh", withExtension: "gif")!
    //    let QText: String = "Ahh, what kind of thoughts are swirling in your mind at this very moment?"
    @State private var isRecmd = false
    @State private var showOptions = false
    @State private var showText = false
    @State private var ExampleRecommendations = [
        ["Ticket to Wallet", "About the Event", "Personal Settings", "Invite a Friend"],
        ["Save to Calendar", "Event Location", "Account Settings", "Help"],
        ["Audio Guide", "Share Experience", "Museum Map", "Gift Shop"],
        ["Rate Visit", "Leave Feedback", "Contact Us", "FAQ"]
    ]
    @State private var currentMatrixIndex = 0
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    
    // Timer for matrix switching
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var currentMatrix: [[String]] {
        let index = currentMatrixIndex % ExampleRecommendations.count
        let nextIndex = (currentMatrixIndex + 1) % ExampleRecommendations.count
        return [
            ExampleRecommendations[index],
            ExampleRecommendations[nextIndex]
        ]
    }
    
    // Main Content
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            // 3D Character
            VStack {
                // AI Chatbot - conditional
                if showText {
                    HStack(alignment: .top) {
                        ScrollView {
                            ForEach(chatController.messages) { message in
                                MessageView(message: message)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 15.0)
                            }
                        }
//                        avatarPhoto
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 35, height: 35)
//                            .clipShape(Circle())
//                        Text(QText)
//                            .foregroundStyle(.white)
//                            .padding(10.0)
//                            .frame(maxWidth: 280)
//                            .background(Color.gray.opacity(0.2).cornerRadius(20))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
                
                // Show Previous Dialogue w/ Tap Gesture
                AnimatedImage(url: gifUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .cornerRadius(20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showText.toggle()
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
                                                .fill(.warmYellow.opacity(0.5))
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
                    
//                    Text("Ask me anything ...")
                    TextField("I want to...", text: self.$string, axis: .vertical)
                        .font(.headline)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.gray.opacity(0.2).cornerRadius(8))
                    
                    Spacer()
                    
                    Button {
                        // Action
                        self.chatController.sendNewMessage(content: string)
                        string = ""
                    } label: {
                        Image(systemName: "paperplane")
                            .padding()
                    }
                }
                .font(.title2)
                .foregroundStyle(.white)
                .padding(8)
            }
            .onAppear {
                // Show Recommendations after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        showOptions = true
                    }
                }
            }
            .onReceive(timer) { _ in
                withAnimation(.spring(duration: 1)) {
                    currentMatrixIndex = (currentMatrixIndex + 1) % ExampleRecommendations.count
                }
            }
        }
    }
}


struct MessageView: View {
    var message: Message
    
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.2).cornerRadius(20))
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.warmYellow.opacity(0.2).cornerRadius(20))
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
