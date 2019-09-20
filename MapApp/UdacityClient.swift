//
//  UdacityClient.swift
//  MapApp
//
//  Created by Elias Hall on 8/20/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

class UdacityClient {
    
//    struct Auth {
//        static var sessionId = ""
//        static var key = ""
//        static var registered = true
//        static var expiration = ""
//    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!) //Base + Endpoint
        request.httpMethod = "POST" //Post Request
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8) //body to be passed
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in //making post request with "request" object
            
            DispatchQueue.main.async {
//            if error != nil { // Handle error…
//                completion(false, error) //if there is an error in the username or password
//                }
//                return
                
                guard error == nil else {
                    print("error")
                    print(response!)
                    return
                }
                
            }
            
            do { //Attempt to Parse Authentication Data
                
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)//changing Data as required for authentication
                
                print(String(data: newData!, encoding: .utf8)!) //printing Data for testing
                
                let decoder = JSONDecoder() //using JSON Decoder for parsing
                do {
                let loginResponseObject2 = try decoder.decode(LoginErrorResponse.self, from: newData!) //parsing. LoginResponse
                print("Status Code: \(loginResponseObject2.statusCode)")
                print("Status Code: \(loginResponseObject2.errorMessage)")
                    ErrorDataStruct.ErrorStatus = loginResponseObject2.statusCode
                    ErrorDataStruct.ErrorMessage = loginResponseObject2.errorMessage
                    
                    DispatchQueue.main.async {
                        
                        completion(false,nil)
                        
                    }
                    return
                }
                
                catch {

                }
                let loginResponseObject = try decoder.decode(LoginResponse.self, from: newData!) //parsing. LoginResponse uses AccountResponse and SessionResponse
                //print("sucessfully parsed auth data")
                print("This is the Key: \(loginResponseObject.account.key)")//Testing parsed constants in structs
                print("This is if Registered: \(loginResponseObject.account.registered)")
                print("This is Expiration: \(loginResponseObject.session.expiration)")
                print("This is the id: \(loginResponseObject.session.id)")
                
                AuthStruct.sessionId = loginResponseObject.session.id
                AuthStruct.key = loginResponseObject.account.key
                AuthStruct.registered = loginResponseObject.account.registered
                AuthStruct.expiration = loginResponseObject.session.expiration
                
//                Auth.sessionId = loginResponseObject.session.id
//                Auth.key = loginResponseObject.account.key
//                Auth.registered = loginResponseObject.account.registered
//                Auth.expiration = loginResponseObject.session.expiration
                
                DispatchQueue.main.async {
                    
                    completion(true,nil)
                    
                }
                
            }
            catch { // If Parsing Fails...
                
                
                print("Parsing failure")
                DispatchQueue.main.async {

                completion(false,nil)
                }
            }
            
        }
        task.resume()
    }
    
    
}
