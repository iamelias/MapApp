//
//  updateLocationClient.swift
//  MapApp
//
//  Created by Elias Hall on 9/10/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class updateLocationClient: UIViewController {
    
  class func update(newLocation: String, newURL: String, newLatitude: Double, newLongitude: Double, completion: @escaping (Bool, Error?) -> Void ){
        
        let currentObjectId = AddStudentClient.ObjectData.ObjectValue //holding initial objectId for comparison
        
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/\(currentObjectId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let updateJSON = resultsResponse(firstName: "Daffy", lastName: "Duck", longitude: newLongitude, latitude: newLatitude, mapString: newLocation, mediaURL: newURL, uniqueKey: "12211", objectId: currentObjectId, createdAt: nil, updatedAt: nil)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(updateJSON) //updating current JSON data by using objectiD
        request.httpBody = data
    
        //print(data)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, nil)
                return
            }
           // print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}
