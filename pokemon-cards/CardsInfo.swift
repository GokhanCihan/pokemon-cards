//
//  PokemonCard.swift
//  pokemon-cards
//
//  Created by Gökhan on 9.11.2022.
//

import Foundation

// constructs a <PokemonCard> type from received data

struct CardsInfo: Codable {
    var cards: [PokemonCard]
}
