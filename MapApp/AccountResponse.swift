//
//  AccountResponse.swift
//  MapApp
//
//  Created by Elias Hall on 8/26/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct AccountResponse: Codable {
    
    let registered: Bool
    let key: String
    
    enum CodingKeys: String,  CodingKey {
        case registered
        case key 
    }
    
}
