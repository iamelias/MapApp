//
//  LoginRequest.swift
//  MapApp
//
//  Created by Elias Hall on 8/20/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacityDictionary: String
    let username: String
    let password: String
    
    enum codingKeys: String, CodingKey {
        case udacityDictionary = "udacity"
        case username
        case password
        
    }



}
