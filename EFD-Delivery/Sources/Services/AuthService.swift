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
        
    static func getInstance() -> AuthService {
        if self.instance == nil {
            self.instance = AuthService()
        }
        return self.instance
    }
    
    func login(email: String, password: String, completion: @escaping (String?) -> Void) -> Void {
        var result: String? = nil
        let body = [
            "email": email,
            "password": password
        ]
        
        let request = API.getInstance().request(route: "/deliveryman/login", method: "POST", body: body)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                return
            }
            DispatchQueue.main.async {
                if let message = json["message"] as? String {
                    self.message = message
                    result = self.message
                }
                if let token = json["token"] as? String {
                    self.token = token
                    result = self.token
                }
                completion(result)
            }
        }
        task.resume()
    }
}
