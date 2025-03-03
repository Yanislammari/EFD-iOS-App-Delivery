//
//  API.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import Foundation

class API {
    private static var instance: API!
    let baseUrl = "http://172.20.10.4:3000"
    
    static func getInstance() -> API {
        if self.instance == nil {
            self.instance = API()
        }
        return self.instance
    }
        
    func request(route: String, method: String, token: String? = nil, body: [String: Any]? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(self.baseUrl)\(route)")!)
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
