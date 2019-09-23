//
//  AddStudentClient.swift
//  MapApp
//
//  Created by Elias Hall on 9/19/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
class AddStudentClient{
    
    struct ObjectData {
        static var ObjectValue: String = "" // stored ObjectId value
        static var ObjectIdent: Bool = false // Does ObjectId exist?
    }
    
    class func postStudentLocation(newLocation: String, newURL: String, newLatitude: Double, newLongitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let addJSON = resultsResponse(firstName: PublicStruct.firstName, lastName: PublicStruct.lastName, longitude: newLongitude, latitude: newLatitude, mapString: newLocation, mediaURL: newURL, uniqueKey: PublicStruct.uniqueKey, objectId: nil, createdAt: nil, updatedAt: nil)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(addJSON)
        request.httpBody = data
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    completion(false,nil)
                }
                return
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, nil)
                    return
                }
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let myData = try decoder.decode(updateLocStruct.self, from: data!) //parsing to myData
                ObjectData.ObjectValue = myData.objectId //storing myData objectId as ObjectValue
                ObjectData.ObjectIdent = true //saving whether objectid exists
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            }
                
            catch {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
            
        }
        task.resume()
    }
}

