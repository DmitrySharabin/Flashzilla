//
//  ContentView-ViewModel.swift
//  Flashzilla
//
//  Created by Dmitry Sharabin on 20.01.2022.
//

import Foundation
import SwiftUI

class CardsViewModel: ObservableObject {
    @Published private(set) var cards = [Card]()
    @Published private(set) var timeRemaining = 100
    @Published private(set) var isActive = true
    
    init() {
        resetCards()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func moveCard(at index: Int) {
        guard index >= 0 else { return }

        var card = cards[index]
        card.id = UUID()

        cards.remove(at: index)
        insertCard(card)
    }
    
    func insertCard(_ card: Card) {
        cards.insert(card, at: 0)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
    }
    
    func resetCards() {
        loadData()
        timeRemaining = 100
        isActive = true
    }
    
    func changeState(for phase: ScenePhase) {
        if phase == .active {
            if cards.isEmpty == false {
                isActive = true
            }
        } else {
            isActive = false
        }
    }
    
    func changeTime() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        }
    }
}
