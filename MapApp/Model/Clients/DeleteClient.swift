//
//  DeleteClient.swift
//  MapApp
//
//  Created by Elias Hall on 9/14/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class DeleteClient {
    
    class func DeleteSession(completion: @escaping () -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        
        let logoutBody = LogoutRequest(sessionId: AuthStruct.sessionId) //encoding sessionId
        request.httpBody = try! JSONEncoder().encode(logoutBody)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                AuthStruct.sessionId = "" //removing sessionId
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completion()
        }
        task.resume()
    }
}
