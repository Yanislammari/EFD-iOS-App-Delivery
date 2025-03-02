//
//  LivraisonTableViewCell.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import UIKit

class LivraisonTableViewCell: UITableViewCell {
    @IBOutlet weak var LivraisonId: UILabel!
    @IBOutlet weak var LivraisonDate: UILabel!
    @IBOutlet weak var LivraisonStatus: UILabel!
    
    func reload(with livraison: Livraison){
        self.LivraisonId.text = "\(livraison.uuid)"
        self.LivraisonDate.text = "\(livraison.livraison_date)"
        self.LivraisonStatus.text = "\(livraison.status)"
    }
}
