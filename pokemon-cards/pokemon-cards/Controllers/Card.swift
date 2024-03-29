//
//  CardsController.swift
//  pokemon-cards
//
//  Created by Gökhan on 24.11.2022.
//

import UIKit

struct Card: Hashable, Sendable, Codable {
    var id: String
    var name: String
    var artist: String
    var smallImageURLString: String
    var largeImageURLString: String
}

// Supposed to work with loading images from API endpoint asynchronously, to load images as they get available
struct Cards: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = Card
    let cards: [Card]
    var index = 0
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    mutating func next() async throws -> Card? {
        guard cards.count > index else {return nil}
        
        let cardAtIndex = cards[index]
        index += 1
        return cardAtIndex
    }
    
    func makeAsyncIterator() -> Cards {
        self
    }
}
