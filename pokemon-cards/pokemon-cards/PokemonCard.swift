//
//  PokemonCard.swift
//  pokemon-cards
//
//  Created by Gökhan on 9.11.2022.
//

import Foundation

struct PokemonCard: Codable {
    var name: String
    var imageUrl: String
    var imageUrlHiRes: String
    var artist: String
    var hp: String
}

// extension PokemonCard {
//
//    struct Comparable {
//        var name: String
//        var imageUrl: String
//        var imageUrlHiRes: String
//        var artist: String
//        var hp: Int
//    }
//
//    var comparable: Comparable {
//
//        return Comparable.init(name: self.name, imageUrl: self.imageUrl, imageUrlHiRes: self.imageUrlHiRes,
//        artist: self.artist, hp: Int(self.hp) ?? 0)
//    }
//
// }
