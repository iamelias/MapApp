//
//  SessionResponse.swift
//  MapApp
//
//  Created by Elias Hall on 8/26/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
struct SessionResponse: Codable {
    
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id 
        case expiration = "expiration"
    }
}
