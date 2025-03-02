//
//  Untitled.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import Foundation

class LivraisonService {
    private static var instance: LivraisonService!
    
    var api: API {
        return API.getInstance()
    }
    
    static func getInstance() -> LivraisonService {
        if self.instance == nil {
            self.instance = LivraisonService()
        }
        return self.instance
    }
    
    func getAllLivraisonForDeliveryMan(token: String, completion: @escaping ([Livraison]) -> Void) -> Void {
        let request = api.request(route: "/deliveryman/livraison", method: "GET", token: token)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                return
            }
            let livraisons = json.compactMap(LivraisonFactory.newInstance(dict:))
            DispatchQueue.main.async {
                completion(livraisons)
            }
        }
        task.resume()
    }
}
