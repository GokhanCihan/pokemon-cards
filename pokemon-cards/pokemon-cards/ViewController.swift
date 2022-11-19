//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class ViewController: UICollectionViewController, URLSessionDelegate {
    var cardList: [PokemonCardData] = []
    var filteredCards: [PokemonCardData]? = nil
    var filterBar: UITextField!
    var task: URLSessionDataTask?
    let session = URLSession(configuration: URLSessionConfiguration.default)

    override func viewDidLoad() {
        super.viewDidLoad()

        filterBar = UITextField(frame: CGRect(x: 30, y: 70, width: 370, height: 30))
        filterBar.layer.masksToBounds = true
        filterBar.layer.cornerRadius = CGFloat(14)
        filterBar.layer.borderWidth = 1.5
        filterBar.layer.borderColor = CGColor(gray: 0.1, alpha: 0.2)
        filterBar.textAlignment = .left
        self.view.addSubview(filterBar)
        
        Task {
            await fetchCards()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredCards = filteredCards {
            return filteredCards.count
        }else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell
        else {
            fatalError("Unable to dequeue CardCell.")
        }
        if let filteredCards = filteredCards {
            cell.pokemonName.text = filteredCards[indexPath.item].name
        }
        return cell
    }
    
    @MainActor
    func fetchCards() async {
        let apiService = APIService(urlString: "https://api.pokemontcg.io/v2/cards")
        do {
            let fetchedResult = try await apiService.getJSON()
            cardList = fetchedResult.data
            print(cardList.count)
        } catch {
            print(error)
        }
    }
    
    func filterCards(byHP HP: Int) -> [PokemonCardData] {
        var filtered: [PokemonCardData] = []
        for card in cardList {
            if let cardHP = Int(card.hp) {
                if cardHP >= HP {
                    filtered.append(card)
                }
            }else {
               break
            }
        }
        return filtered
    }

}
