//
//  CardsController.swift
//  pokemon-cards
//
//  Created by Gökhan on 24.11.2022.
//

import UIKit

class CardsController {
    var cards = [Card]()
    
    struct Card: Hashable {
        let id: String
        let name: String
        let artist: String
        let hp: Int
        let smallImage: URL
        let largeImage: URL
        
        func isEqualOrGreater(_ filter: String?) -> Bool {
            guard
                let typedHp = filter else { return true }
            if typedHp.isEmpty {
                return false
            }
            if
                let typedHp = Int(typedHp) {
                return hp >= typedHp
            }else {
                return false
            }
        }
    }
    
}

extension CardsController {
    func generateCards(cardData: [CardData]) -> [Card] {
        return cardData.map {
            Card(id: $0.id, name: $0.name, artist: $0.artist, hp: Int($0.hp)!, smallImage: URL(string: $0.images.small)!, largeImage: URL(string: $0.images.large)!)
        }
    }
    
    func filterCards(with filter: String?=nil, limit: Int?=nil) -> [Card] {
        return cards.filter { $0.isEqualOrGreater(filter) }
    }
}
