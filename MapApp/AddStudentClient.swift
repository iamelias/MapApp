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
        static var ObjectValue: String = ""
        static var ObjectIdent: Bool = false
    }
    
    class func postStudentLocation(newLocation: String, newURL: String, newLatitude: Double, newLongitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let addJSON = resultsResponse(firstName: "Barry", lastName: "Doe", longitude: newLongitude, latitude: newLatitude, mapString: newLocation, mediaURL: newURL, uniqueKey: "12211", objectId: nil, createdAt: nil, updatedAt: nil)
        
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
                    
                    let myData = try decoder.decode(updateLocStruct.self, from: data!) //parsing
                     ObjectData.ObjectValue = myData.objectId
                    ObjectData.ObjectIdent = true
                    
                    DispatchQueue.main.async {
                        completion(true,nil)
                    }
                    
                }
                    
                catch {
                    DispatchQueue.main.async {
                        print("parsing failed")
                        completion(false, nil)
                    }
                }
                
            }
        task.resume()

}
}


//        request.httpBody = "{\"uniqueKey\": \"2321\", \"firstName\": \"Jonny\", \"lastName\": \"Tom\",\"mapString\": \(newLocation), \"mediaURL\": \(newURL),\"latitude\": \(newLatitude), \"longitude\": \(newLongitude)}".data(using: .utf8)
