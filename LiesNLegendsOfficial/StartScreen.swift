import SwiftUI
import AVFoundation




// MARK: - Start Screen struct
struct StartScreen: View {
    
    @Environment(\.modelContext) private var context
    
    //Made the Audio an Enviormental Object so it can be called on any view and muted from any view by the user.
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        //The Gaming Navigation View keeps the RUles and the Audio systemImages in the top toolbar so we can access rules and the music of/on from any screen
        GameNavigationView {
            VStack(spacing: 20) {
                
                //Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .padding()
                
                Spacer()
                
                //Card Flip Animation
                ContFlipView()
                
                Spacer()
                
                //Play button to start the game and takw you to adding the List of Players
                NavigationLink {
                    ListOfPlayers()
                } label: {
                    GlossyButtonView(text: "PLAY", backgroundColor: .primary)
                }
                Spacer()
            }
            
        }
    }
}

#Preview {
    StartScreen()
        .environmentObject(AudioManager())
        .modelContainer(for: Player.self, inMemory: true)
}



//The Gaming Navigation View keeps the RUles and the Audio systemImages in the top toolbar so we can access rules and the music of/on from any screen and it has the enviormental audio in it
struct GameNavigationView<Content: View>: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var showRules = false
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showRules.toggle() }) {
                            Image(systemName: "text.page.badge.magnifyingglass")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { audioManager.toggleMusic() }) {
                            Image(systemName: audioManager.isPlaying ? "speaker.wave.2" : "speaker.slash")
                                .font(.title2)
                                .foregroundStyle(audioManager.isPlaying ? .primary : .secondary)
                        }
                    }
                }
                .sheet(isPresented: $showRules) {
                    RulesScreen()
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.large])
                        .presentationCornerRadius(20)
                }
                .tint(.primary)
        }
    }
}

// MARK: - Card Flip For Start Screen
/// This is used on the Start Screen to provide a nice animation of the card flipping before the user gets into the app to let them know that this is a Card Game
struct ContFlipView: View {
    @State private var isFlipped = false
    @State private var angle: Double = 0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Image("CardBack")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 350)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
            
            Image("CardBack")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 350)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(angle + 180), axis: (x: 0, y: 1, z: 0))
        }
        .onAppear {
            startFlipping()
        }
        .onDisappear {
            stopFlipping()
        }
    }
    
    
    /// For making the startscreen card flip
    func startFlipping() {
        timer?.invalidate() // cancel any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.8)) {
                angle += 180
                angle = angle.truncatingRemainder(dividingBy: 360)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFlipped.toggle()
            }
        }
    }
    
    func stopFlipping() {
        timer?.invalidate()
        timer = nil
    }
}
