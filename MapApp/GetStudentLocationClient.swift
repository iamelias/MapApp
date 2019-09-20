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
    
    //static var ResponseData: [resultsResponse] = []  //contains student locations
    
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
                let myResponseObjects2 = myResponseObjects
                 print("parsing successful")
                // print(myResponseObjects)
                 print("Reached 4")
                
                //GetStudentLocation.ResponseData = myResponseObjects.results //storing into results ResponseData property
                DataHoldStruct.ResponseDataArray = myResponseObjects2.results //saving data using LocationStruct.swift
                
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
