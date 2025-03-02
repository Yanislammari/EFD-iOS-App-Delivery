//
//  Colis.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

class Colis {
    let uuid: String;
    let destination_name: String;
    let adress_id: String;
    let livraison_id: String;
    let status: String;
    let lgt: Float
    let lat: Float
    let image_path: String?
    
    init(uuid: String, destination_name: String, adress_id: String, livraison_id: String, status: String, lgt: Float, lat: Float, image_path: String?) {
        self.uuid = uuid
        self.destination_name = destination_name
        self.adress_id = adress_id
        self.livraison_id = livraison_id
        self.status = status
        self.lgt = lgt
        self.lat = lat
        self.image_path = image_path
    }
}
