//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class ViewController: UICollectionViewController, URLSessionDelegate {
    var cardList: [PokemonCard.Comparable]? = nil
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.pokemontcg.io/v1/cards?hp=gte99")!

        getData(from: url)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList?.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell.")
        }
        
        if let cardList = cardList {
            var card = cardList[indexPath.item]
            
            let task = session.dataTask(with: URL(string: card.imageUrl)!) {
                (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("not 200")
                    return
                }
                
                guard let data = data else{
                    print(error.debugDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.cardImage.image = UIImage(data: data)
                    cell.pokemonName.text = card.name
                }
                
            }
            task.resume()
        }
        
        return cell
    }
    
    func getData(from url: URL) {
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("not 200 get data")
                return
            }
            
            guard let data = data else{
                print(error.debugDescription)
                return
            }
            
            self.parse(data)
        }
        task.resume()
    }
    
    func parse(_ json: Data) {
        var templist = [PokemonCard.Comparable]()
        let decoder = JSONDecoder()
        if let result = try? decoder.decode(CardsInfo.self, from: json){
            for card in result.cards {
                    templist.append(card.comparable)
            }
            self.cardList = templist
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}

