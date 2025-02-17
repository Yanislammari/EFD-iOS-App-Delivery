//
//  DeliveryManService.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 16/02/2025.
//

import Foundation

class DeliveryManService {
    static var instance: DeliveryManService!
    var deliveryManConnected: DeliveryMan? = nil
    
    var api: API {
        return API.getInstance()
    }
    
    static func getInstance() -> DeliveryManService {
        if self.instance == nil {
            self.instance = DeliveryManService()
        }
        return self.instance
    }
    
    func getDeliveryManById(id: String, token: String, completion: @escaping (DeliveryMan) -> Void) -> Void {
        let request = self.api.request(route: "/deliver/delivery_man/\(id)", method: "GET", token: token)
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
            if let deliveryMan = DeliveryManFactory.newInstance(dict: json) {
                DispatchQueue.main.async {
                    completion(deliveryMan)
                }
            }
        }
        task.resume()
    }
}
