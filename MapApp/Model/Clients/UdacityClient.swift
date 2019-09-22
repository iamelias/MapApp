//
//  UdacityClient.swift
//  MapApp
//
//  Created by Elias Hall on 8/20/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

class UdacityClient { //Authentication Posting for Login
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!) //Base + Endpoint
        request.httpMethod = "POST" //Post Request
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8) //body to be passed
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in //making post request with "request" object
            
            guard data != nil else {
                DispatchQueue.main.async {
                    completion(false,nil)
                }
                return
            }
            
            if error != nil {
                DispatchQueue.main.async {
                ErrorDataStruct.ErrorStatus = 0
                    completion(false, nil)
                    return
                }
            }
            
            do { //Attempt to Parse Authentication Data
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)//changing Data as required for authentication
                                
                let decoder = JSONDecoder() //using JSON Decoder for parsing
                do {
                let loginResponseObject = try decoder.decode(LoginErrorResponse.self, from: newData!) //parsing. LoginResponse

                    ErrorDataStruct.ErrorStatus = loginResponseObject.statusCode
                    ErrorDataStruct.ErrorMessage = loginResponseObject.errorMessage
                    
                    DispatchQueue.main.async {
                        completion(false,nil)
                    }
                    return
                }
                
                catch {
                    //continue
                }
                let loginResponseObject = try decoder.decode(LoginResponse.self, from: newData!) //parsing. LoginResponse uses AccountResponse and SessionResponse

                AuthStruct.sessionId = loginResponseObject.session.id //Saving Authorization data in AuthStruct
                AuthStruct.key = loginResponseObject.account.key
                AuthStruct.registered = loginResponseObject.account.registered
                AuthStruct.expiration = loginResponseObject.session.expiration

                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            }
            catch { // If Parsing Fails...
                
                DispatchQueue.main.async {
                completion(false,nil)
                }
            }
        }
        task.resume()
    }
}
