//
//  ContentView.swift
//  Flashzilla
//
//  Created by Dmitry Sharabin on 16.01.2022.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var vm = CardsViewModel()
    @State private var showingEditScreen = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(vm.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(vm.cards) { card in
                        let index = vm.cards.firstIndex(of: card) ?? 0
                        
                        CardView(card: card) { isWrong in
                            withAnimation {
                                if isWrong {
                                    vm.moveCard(at: index)
                                } else {
                                    vm.removeCard(at: index)
                                }
                            }
                        }
                        .stacked(at: index, in: vm.cards.count)
                        .allowsHitTesting(index == vm.cards.count - 1)
                        .accessibilityHidden(index < vm.cards.count - 1)
                    }
                }
                .allowsHitTesting(vm.timeRemaining > 0)
                
                if vm.cards.isEmpty {
                    Button("Start Again", action: vm.resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                vm.moveCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your card as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard vm.isActive else { return }
            
            vm.changeTime()
        }
        .onChange(of: scenePhase, perform: vm.changeState)
        .sheet(isPresented: $showingEditScreen, onDismiss: vm.resetCards) {
            EditCards(vm: vm)
        }
        .onAppear {
            if vm.cards.isEmpty {
                showingEditScreen = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
