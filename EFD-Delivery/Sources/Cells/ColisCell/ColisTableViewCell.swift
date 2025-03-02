//
//  ColisTableViewCell.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import UIKit

class ColisTableViewCell: UITableViewCell {
    @IBOutlet weak var colisId: UILabel!
    @IBOutlet weak var colisDestinationName: UILabel!
    @IBOutlet weak var colisStatus: UILabel!
    
    func reload(with colis: Colis){
        self.colisId.text = "\(colis.uuid)"
        self.colisDestinationName.text = "\(colis.destination_name)"
        self.colisStatus.text = "\(colis.status)"
    }
}
