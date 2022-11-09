//
//  ViewController.swift
//  pokemon-cards
//
//  Created by Gökhan on 8.11.2022.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "https://api.pokemontcg.io/v1/cards?hp=gte99")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                print(error.debugDescription)
                return
            }
            
            if let recievedDataAsString = String(data: data, encoding: .utf8) {
                print(recievedDataAsString)
            }
        }
        
        task.resume()
    }
}

