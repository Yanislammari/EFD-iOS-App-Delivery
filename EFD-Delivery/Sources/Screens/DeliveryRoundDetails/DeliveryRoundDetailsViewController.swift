//
//  DeliveryRoundDetailsViewController.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import UIKit

class DeliveryRoundDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var colisTableView: UITableView!
    var colis: [Colis] = []
    var livraison: Livraison!
    
    var colisService: ColisService {
        return ColisService.getInstance()
    }
    
    static func newInstance(livraison: Livraison) -> DeliveryRoundDetailsViewController {
        let deliveryRoundDetailsViewController = DeliveryRoundDetailsViewController()
        deliveryRoundDetailsViewController.livraison = livraison
        return deliveryRoundDetailsViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colis.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aColis = self.colis[indexPath.row]
        if let imagePath = aColis.image_path, !imagePath.isEmpty {
            return 300
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aColis = self.colis[indexPath.row]
        
        if let imagePath = aColis.image_path, !imagePath.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "COLIS_WITH_PHOTO_CELL_ID", for: indexPath) as! ColisWithPhotoTableViewCell
            cell.reload(with: aColis)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "COLIS_CELL_ID", for: indexPath) as! ColisTableViewCell
            cell.reload(with: aColis)
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colisCellNib = UINib(nibName: "ColisTableViewCell", bundle: nil)
        self.colisTableView.register(colisCellNib, forCellReuseIdentifier: "COLIS_CELL_ID")
        
        let colisWithPhotoCellNib = UINib(nibName: "ColisWithPhotoTableViewCell", bundle: nil)
        self.colisTableView.register(colisWithPhotoCellNib, forCellReuseIdentifier: "COLIS_WITH_PHOTO_CELL_ID")
        
        self.colisTableView.dataSource = self
        self.colisTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colisService.getColisOfLivraisonById(id: livraison.uuid) { allColis in
            self.colis = allColis
            self.colisTableView.reloadData()
        }
    }
}
