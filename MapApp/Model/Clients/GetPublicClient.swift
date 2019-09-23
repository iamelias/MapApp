//
//  GetPublicClient.swift
//  MapApp
//
//  Created by Elias Hall on 9/22/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class GetPublicClient {
    
    class func publicInfo(completion: @escaping  (Bool, Error?) -> Void) {
        
        let locationsEndpointRequest = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!) //accessing getting public user data
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
            
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let myPublicObjects = try decoder.decode(UserDetailResponse.self, from: newData!) //parsing
                //print(myPublicObjects)
                
                PublicStruct.firstName = myPublicObjects.firstName //saving data to PublicStruct static variables
                PublicStruct.lastName = myPublicObjects.lastName
                PublicStruct.uniqueKey = myPublicObjects.uniqueKey
                
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

