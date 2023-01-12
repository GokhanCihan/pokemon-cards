//
//  APIService.swift
//  pokemon-cards
//
//  Created by Gökhan on 16.11.2022.
//

import Foundation
import UIKit

/*
 documentation: "https://docs.pokemontcg.io/api-reference/"
 
 search with parameter: "https://api.pokemontcg.io/v2/cards?q=", append querry parameter
 
 search HP range: "https://api.pokemontcg.io/v2/cards?q=hp:", append range:
 "{100%20TO%20*}" means "an open range of values greater than 100"
 
 order results: "https://api.pokemontcg.io/v2/cards?q=hp:{100%20TO%20*}&orderBy=", append parameter:
 such as "hp", "number" etc.
 
 limit number of returning cards: ""https://api.pokemontcg.io/v2/cards?q=hp:{100%20TO%20*}&pageSize=",
 append integer: default = "250"
 */

struct APIService {
    var stringAPIURL: String
    
    init(_ stringAPIURL: String) {
        self.stringAPIURL = stringAPIURL
    }
    
    func getJSON<T>(for type: T.Type) async throws -> T where T: Decodable {
        do {
            return try await self.decodeJSON(for: T.self, from: self.dataResponseOfRequest())
        } catch {
            throw error
        }
    }
    
    func dataResponseOfRequest() async throws -> Data {
        let (data, urlResponse) = try await URLSession.shared.data(from: self.request())
        guard
            let httpResponse = urlResponse as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw APIError.invalidResponse
        }
        return data
    }
    
    func request() throws -> URL {
        let url = try self.createURL()
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "X-Api-Key": "e61fbaee-7eaa-4759-9818-77b6f4ea2bac"
        ]
        return url
    }
    
    func createURL() throws -> URL {
        guard
            let url = URL(string: self.stringAPIURL)
        else {
            throw APIError.invalidURL
        }
        return url
    }
    
    func decodeJSON<T>(for type: T.Type, from data: Data) throws -> T where T: Decodable {
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw error
        }
    }
    
    func getImage() async throws -> UIImage {
        let url = try createURL()
        
        let data = try? Data(contentsOf: url)
        if let image = UIImage(data: data!) {
            return image
        }else {
            return UIImage(named: "notFound.jpg")!
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
