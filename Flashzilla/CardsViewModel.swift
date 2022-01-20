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
    
    private let savePath: URL
    
    init() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        savePath = paths[0].appendingPathComponent("Cards")
        
        resetCards()
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            cards = []
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
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
        guard cards.isEmpty == false else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        }
    }
}
