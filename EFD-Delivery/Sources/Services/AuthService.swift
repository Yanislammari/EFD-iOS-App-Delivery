//
//  AuthService.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import Foundation

class AuthService {
    private static var instance: AuthService!
    var message: String? = nil
    var token: String? = nil
    
    var api: API {
        return API.getInstance()
    }
        
    static func getInstance() -> AuthService {
        if self.instance == nil {
            self.instance = AuthService()
        }
        return self.instance
    }
    
    func login(email: String, password: String, completion: @escaping () -> Void) -> Void {
        let body = [
            "email": email,
            "password": password
        ]
        
        let request = api.request(route: "/deliveryman/login", method: "POST", body: body)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            DispatchQueue.main.async {
                if let message = json["message"] as? String {
                    self.message = message
                }
                if let token = json["token"] as? String {
                    self.token = token
                }
                completion()
            }
        }
        task.resume()
    }
    
    func decodeToken(token: String, completion: @escaping (String) -> Void) -> Void {
        let request = api.request(route: "/decode-token", method: "GET", token: token)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                return
            }
            let userId = json["userId"]
            DispatchQueue.main.async {
                completion(userId!)
            }
        }
        task.resume()
    }
}
