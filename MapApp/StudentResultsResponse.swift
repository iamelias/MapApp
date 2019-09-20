//
//  StudentResultsResponse.swift
//  MapApp
//
//  Created by Elias Hall on 8/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct resultsResponse: Codable {
    
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mapString: String
    var mediaURL: String?
    var uniqueKey: String
    var objectId: String?
    var createdAt: String?
    var updatedAt: String?
    
    
    enum CodingKeys: String, CodingKey {
        
        
        case firstName
        case lastName
        case longitude
        case latitude
        case mapString
        case mediaURL
        case uniqueKey
        case objectId
        case createdAt
        case updatedAt
        
    }
}

