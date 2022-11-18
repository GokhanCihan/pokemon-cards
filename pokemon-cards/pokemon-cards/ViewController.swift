//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class ViewController: UICollectionViewController, URLSessionDelegate {
    var cardList: [PokemonCardData] = []
    var filteredCards: [PokemonCardData] = []
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
        return cardList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell
        else {
            fatalError("Unable to dequeue CardCell.")
        }

        return cell
    }
    
    @MainActor
    func fetchCards() async {
        let apiService = APIService(urlString: "https://api.pokemontcg.io/v2/cards")
        do {
            let fetchedResult = try await apiService.getJSON()
            cardList = fetchedResult.data
        } catch {
            print(error)
        }
    }

}
