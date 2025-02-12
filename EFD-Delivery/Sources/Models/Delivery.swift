//
//  Delivery.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import Foundation

class Delivery {
    let id: UUID
    let firstName: String
    let lastName: String
    let phone: String
    let status: String
    let email: String
    let password: String
    
    init(id: UUID, firstName: String, lastName: String, phone: String, status: String, email: String, password: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.status = status
        self.email = email
        self.password = password
    }
}
