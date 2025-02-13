//
//  ToastHandler.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 13/02/2025.
//

import UIKit

class ToastHandler {
    private static var instance: ToastHandler!
    
    static func getInstance() -> ToastHandler {
        if self.instance == nil {
            self.instance = ToastHandler()
        }
        return self.instance
    }
    
    func showToast(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        alert.view.layer.cornerRadius = 15
        viewController.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
