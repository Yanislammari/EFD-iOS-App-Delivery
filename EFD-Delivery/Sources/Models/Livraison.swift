//
//  Livraison.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

class Livraison {
    let uuid: String;
    let deliveryman_id: String;
    let livraison_date: String;
    let status: String;
    
    init(uuid: String, deliveryman_id: String, livraison_date: String, status: String) {
        self.uuid = uuid
        self.deliveryman_id = deliveryman_id
        self.livraison_date = livraison_date
        self.status = status
    }
}
