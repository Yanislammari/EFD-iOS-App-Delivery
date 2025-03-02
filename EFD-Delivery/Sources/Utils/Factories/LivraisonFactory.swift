//
//  LivraisonFactory.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

class LivraisonFactory {
    static func newInstance(dict: [String: Any]) -> Livraison? {
        guard
            let uuid = dict["uuid"] as? String,
            let deliveryman_id = dict["deliveryman_id"] as? String,
            let livraison_date = dict["livraison_date"] as? String,
            let status = dict["status"] as? String
        else {
            return nil
        }
        
        return Livraison(uuid: uuid, deliveryman_id: deliveryman_id, livraison_date: livraison_date, status: status)
    }
}
