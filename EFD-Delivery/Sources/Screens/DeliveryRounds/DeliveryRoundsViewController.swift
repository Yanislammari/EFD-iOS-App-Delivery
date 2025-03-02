//
//  DeliveryRoundsViewController.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 15/02/2025.
//

import UIKit

class DeliveryRoundsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var livraisonsTableView: UITableView!
    var livraisons : [Livraison] = []
    
    var livraisonService: LivraisonService {
        return LivraisonService.getInstance()
    }
    
    var authService: AuthService {
        return AuthService.getInstance()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "LivraisonTableViewCell", bundle: nil)
        self.livraisonsTableView.register(cellNib, forCellReuseIdentifier: "LIVRAISON_CELL_ID")
        self.livraisonsTableView.dataSource = self
        self.livraisonsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.livraisonService.getAllLivraisonForDeliveryMan(token: authService.token!) { allLivraisons in
            self.livraisons = allLivraisons
            self.livraisonsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.livraisons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let livraison = self.livraisons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LIVRAISON_CELL_ID",for: indexPath) as! LivraisonTableViewCell
        cell.reload(with: livraison)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let livraison = self.livraisons[indexPath.row]
        let livraisonDetailsScreen = DeliveryRoundDetailsViewController.newInstance(livraison: livraison)
        self.navigationController?.pushViewController(livraisonDetailsScreen, animated: true)
    }
}
