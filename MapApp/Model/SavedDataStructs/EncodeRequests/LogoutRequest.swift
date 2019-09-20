//
//  LogoutRequest.swift
//  MapApp
//
//  Created by Elias Hall on 9/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct LogoutRequest: Codable { //Used in DeleteClient.swift
    let sessionId: String
}

enum CodingKeys: String, CodingKey {
    case sessionId = "id"
}

