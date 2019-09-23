//
//  UserDetailResponse.swift
//  MapApp
//
//  Created by Elias Hall on 9/22/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct UserDetailResponse: Codable {
    
    let firstName: String
    let lastName: String
    let uniqueKey: String
    
    enum CodingKeys: String, CodingKey {
        
        case firstName = "first_name"
        case lastName = "last_name"
        case uniqueKey = "key"
    }
}
