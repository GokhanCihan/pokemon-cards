//
//  APIService.swift
//  pokemon-cards
//
//  Created by Gökhan on 16.11.2022.
//

import Foundation
import UIKit

struct APIService {
    let urlString: String
    
    func getJSON() async throws -> [CardsController.Card] {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "X-Api-Key": "e61fbaee-7eaa-4759-9818-77b6f4ea2bac"
        ]
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = urlResponse as? HTTPURLResponse,
                    httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponse
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(PokemonTCG.self, from: data)
                let editedData = try decodedData.data.map{
                    CardsController.Card(id: $0.id,
                         name: $0.name,
                         artist: $0.artist,
                         hp: Int($0.hp)!,
                         smallImage: try getImage(urlString: $0.images.small),
                         largeImage: try getImage(urlString: $0.images.large))
                }
                return editedData
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func getImage(urlString: String) throws -> UIImage {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data){
                return image
            }else {
                return UIImage(named: "notFound")!
            }
        } catch {
            throw error
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case dataTaskError(String)
    case incompatibleData
    case dataDecodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("invalid URL", comment: "")
        case .invalidResponse:
            return NSLocalizedString("invalid response status", comment: "")
        case .dataTaskError(let string):
            return string
        case .incompatibleData:
            return NSLocalizedString("incompatible data?", comment: "this is a comment")
        case .dataDecodingError(let string):
            return string
        }
    }
}
