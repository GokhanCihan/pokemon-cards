//
//  DefaultsHandler.swift
//  pokemon-cards
//
//  Created by Gökhan on 13.01.2023.
//

import Foundation
import UIKit

struct DefaultsHandler {
    let defaults = UserDefaults.standard
    
    func updateDefaults<T>(with value: T, forKey key: String) throws where T: Encodable {
        let jsonEncoder = JSONEncoder()
        
        do{
            let data = try jsonEncoder.encode(value)
            defaults.set(T.self, forKey: key)
        }catch {
            throw error
        }
    }
    
}
