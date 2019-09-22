//
//  GetStudentLocation.swift
//  MapApp
//
//  Created by Elias Hall on 8/28/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//
//This code gets retrieves student information from server for map/table views. Uses GET
import Foundation
class GetStudentLocationClient {
    
    class func getStudentLocations(completion: @escaping (Bool, Error?) -> Void) {
        
        let locationsEndpointRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!) //number of object returned= 100, returned in reversed order from most recent entry-> first entry
        let session = URLSession.shared
        
        let task = session.dataTask(with: locationsEndpointRequest) { data, response, error in
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
                
                let myResponseObjects = try decoder.decode(StudentLocationResponse.self, from: data!) //parsing
                
                DataHoldStruct.ResponseDataArray = myResponseObjects.results //saving data to array
                
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
