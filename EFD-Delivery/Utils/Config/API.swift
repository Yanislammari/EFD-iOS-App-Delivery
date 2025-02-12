//
//  API.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import Foundation

class API {
    private static var instance: API!
    
    class func getInstance() -> API {
        if self.instance == nil {
            self.instance = API()
        }
        return self.instance
    }
    
    let baseUrl = URL(string: "http://localhos:3000")
    
    func request(route: String, method: String, token: String?, body: [String: Any]?) -> URLRequest {
        var request = URLRequest(url: self.baseUrl!)
        request.httpMethod = method
        
        if let token = token {
            request.setValue("BEARER \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonBody
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
