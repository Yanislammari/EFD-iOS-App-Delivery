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
    
    func updateDeliveryManPosition(id: String, token: String, lat: Float, lng: Float, completion: @escaping () -> Void) {
        let body = [
            "lat": lat,
            "lng": lng
        ]
        
        let request = self.api.request(route: "/delivery_man/\(id)", method: "PATCH", token: token, body: body)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                error == nil,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                return
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
}
