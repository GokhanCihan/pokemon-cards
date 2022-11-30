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
        let largeImage: UIImage
        
        func isEqualOrGreater(_ filter: String?) -> Bool {
            guard
                let typedHp = filter else { return true }
            if typedHp.isEmpty {
                return true
            }
            if
                let typedHp = Int(typedHp) {
                return hp >= typedHp
            }else {
                return true
            }
        }
    }
}
