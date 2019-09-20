//
//  LoginErrorResponse.swift
//  MapApp
//
//  Created by Elias Hall on 9/16/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct LoginErrorResponse: Codable { // If login fails the error is parsed for alert
    
    let statusCode: Int
    let errorMessage: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case statusCode = "status"
        case errorMessage = "error"
    }
}
