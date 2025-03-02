//
//  ColisWithPhotoTableViewCell.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import UIKit

class ColisWithPhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var colisId: UILabel!
    @IBOutlet weak var colisDestinationName: UILabel!
    @IBOutlet weak var colisStatus: UILabel!
    @IBOutlet weak var colisImage: UIImageView!
    
    var api: API {
        return API.getInstance()
    }
    
    func reload(with colis: Colis) {
        self.colisId.text = "\(colis.uuid)"
        self.colisDestinationName.text = "\(colis.destination_name)"
        self.colisStatus.text = "\(colis.status)"
        
        let imageUrlString = api.baseUrl + (colis.image_path ?? "")
        
        guard let imageURL = URL(string: imageUrlString) else {
            return
        }
                
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                return
            }
            
            guard let data = data else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.colisImage.image = image
            }
        }.resume()
    }

}
