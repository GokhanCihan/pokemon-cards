//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {

    var cardList = [PokemonCard.Comparable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "https://api.pokemontcg.io/v1/cards?hp=gte99")!
        

        getData(with: session, from: url)
        
    }
    
    func getData(with session: URLSession, from url: URL) {
        
        let task = session.dataTask(with: url) {
            (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
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
        let decoder = JSONDecoder()
        
        if let result = try? decoder.decode(CardsInfo.self, from: json){
            for card in result.cards {
                cardList.append(card.comparable)
            }

        }
        
        print(cardList)

    }
    
}

