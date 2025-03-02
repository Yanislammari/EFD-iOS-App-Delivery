//
//  DeliveryFactory.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import Foundation

class DeliveryManFactory {
    static func newInstance(dict: [String: Any]) -> DeliveryMan? {
        guard
            let id = dict["uuid"] as? String,
            let firstName = dict["first_name"] as? String,
            let lastName = dict["name"] as? String,
            let phone = dict["phone"] as? String,
            let status = dict["status"] as? String,
            let email = dict["email"] as? String,
            let password = dict["password"] as? String
        else {
            return nil
        }
        
        return DeliveryMan(id: id, firstName: firstName, lastName: lastName, phone: phone, status: status, email: email, password: password)
    }
}
