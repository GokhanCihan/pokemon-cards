//
//  CardsController.swift
//  pokemon-cards
//
//  Created by Gökhan on 24.11.2022.
//

import UIKit

class CardsController {
    
    struct Card: Hashable {
        let id: String
        let name: String
        let artist: String
        let hp: Int
        let smallImage: UIImage
        let largeImage: String
        var isFavorite: Bool
        
        func isEqualOrGreater(_ filter: Int) -> Bool {
            return hp >= filter
        }
        func isNameEqual(_ filter: String) -> Bool {
            return name == filter
        }
    }
}
