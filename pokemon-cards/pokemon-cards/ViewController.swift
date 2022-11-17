//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class ViewController: UICollectionViewController, URLSessionDelegate {
    var cardList: [PokemonCard] = []
    var filteredCards: [PokemonCard] = []
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
        let imageUrl = cardList[indexPath.item].imageUrl
        
        Task {
            cell.cardImage.image = await fetchImage(from: imageUrl)
            cell.pokemonName.text = cardList[indexPath.item].name
        }
        return cell
    }
    
    @MainActor
    func fetchCards() async {
        let apiService = APIService(urlString: "https://api.pokemontcg.io/v1/cards?hp=gte99")
        do {
            cardList = try await apiService.getJSON()
        } catch {
            print(debugDescription)
        }
    }
    
    @MainActor
    func fetchImage(from urlString: String) async -> UIImage {
        var imageData = Data()
        let image = UIImage()
        let apiService = APIService(urlString: urlString)
        do {
            imageData = try await apiService.getJSON()
            if let image = UIImage(data: imageData) {
                return image
            }else {
                print("fetch error")
            }
        }catch {
        }
        return image
    }

}
