//
//  DeliveryFactory.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import Foundation

class DeliveryFactory {
    class func newInstance(dict: [String: Any]) -> Delivery? {
        guard
            let id = UUID(uuidString: (dict["id"] as? String)!),
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let phone = dict["phone"] as? String,
            let status = dict["status"] as? String,
            let email = dict["email"] as? String,
            let password = dict["password"] as? String
        else {
            return nil
        }
        
        return Delivery(id: id, firstName: firstName, lastName: lastName, phone: phone, status: status, email: email, password: password)
    }
}
