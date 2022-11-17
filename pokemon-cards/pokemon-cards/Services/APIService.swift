//
//  APIService.swift
//  pokemon-cards
//
//  Created by Gökhan on 16.11.2022.
//

import Foundation

struct APIService {
    let urlString: String
    
    func getJSON<T: Decodable>() async throws -> T {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
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
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.dataDecodingError(error.localizedDescription)
            }
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
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
