//
//  StudentLocationResponse.swift
//  MapApp
//
//  Created by Elias Hall on 8/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    
    var results: [resultsResponse]
    
    enum CodingKeys: String, CodingKey {
       
        case results
    }
    
    }

