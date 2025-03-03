//
//  ColisFactory.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import Foundation

class ColisFactory {
    static func newInstance(dict: [String: Any]) -> Colis? {
        guard
            let id = dict["uuid"] as? String,
            let destination_name = dict["destination_name"] as? String,
            let adress_id = dict["adress_id"] as? String,
            let livraison_id = dict["livraison_id"] as? String,
            let status = dict["status"] as? String,
            let lgt = (dict["lgt"] as? NSNumber)?.floatValue,
            let lat = (dict["lat"] as? NSNumber)?.floatValue
        else {
            return nil
        }
        
        let image_path = dict["image_path"] as? String
        
        return Colis(uuid: id, destination_name: destination_name, adress_id: adress_id, livraison_id: livraison_id, status: status, lgt: lgt, lat: lat, image_path: image_path)
    }
}
