//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class CardsViewController: UIViewController, URLSessionDelegate {
    
    enum Section: CaseIterable {
        case main
    }
    
    let cardsController = CardsController()
    var cardsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, CardsController.Card>!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    let searchBar = UISearchBar(frame: .zero)
    
    var cardData: [CardData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            cardData = try await fetchCardData()
            cardsController.cards = cardsController.generateCards(cardData: cardData)
        }
    }
    
    @MainActor
    func fetchCardData() async throws -> [CardData] {
        let apiService = APIService(urlString: "https://api.pokemontcg.io/v2/cards")
        do {
            let fetchedResult = try await apiService.getJSON()
            return fetchedResult.data
        } catch {
            throw error
        }
    }
}

extension CardsViewController {
    
    func configureDataSource() {
        
    }
    
    func performQuery() {
    
    }
}
extension CardsViewController {
    
    func createLayout() {
        
    }
    
    func configureLayout() {
        
    }
}

extension CardsViewController: UISearchBarDelegate {
    
}
