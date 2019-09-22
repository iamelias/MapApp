//
//  LoginResponse.swift
//  MapApp
//
//  Created by Elias Hall on 8/25/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let account: AccountResponse
    let session: SessionResponse
    
}
