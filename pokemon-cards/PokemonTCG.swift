//
//  PokemonCard.swift
//  pokemon-cards
//
//  Created by Gökhan on 9.11.2022.
//

import Foundation

// parse data recieved from Pokémon TCG API
// PokemonTCG
//   data     ->    CardData
//   page              id
//  pageSize          name
//   count             hp
// totalCount        artist
//                   images       -> CardImages
//                                     small
//                                     large
//

import Foundation

// MARK: - PokemonTCG
struct PokemonTCG: Codable {
    var data: [CardData]
    var page, pageSize, count, totalCount: Int
}

// MARK: - CardData
struct CardData: Codable {
    var id, name: String
    var hp: String
    var artist: String
    var images: CardImages
}

// MARK: - CardImages
struct CardImages: Codable {
    var small, large: String
}
