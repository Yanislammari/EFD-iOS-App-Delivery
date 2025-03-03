//
//  NavigationHandler.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 15/02/2025.
//

import UIKit

class NavigationHandler {
    private static var instance: NavigationHandler!
    let deliveriesMapScreen = DeliveriesMapViewController(nibName: "DeliveriesMapViewController", bundle: nil)
    let deliveryRoundsScreen = DeliveryRoundsViewController(nibName: "DeliveryRoundsViewController", bundle: nil)
    
    static func getInstance() -> NavigationHandler {
        if self.instance == nil {
            self.instance = NavigationHandler()
        }
        return self.instance
    }
    
    func initNavigation() -> UIViewController {
        self.deliveriesMapScreen.tabBarItem.title = String(localized: "MAP_TITLE")
        self.deliveriesMapScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        self.deliveriesMapScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.systemIndigo], for: .selected)
        self.deliveriesMapScreen.tabBarItem.image = UIImage(systemName: "map.fill")
        self.deliveriesMapScreen.tabBarItem.image = self.deliveriesMapScreen.tabBarItem.image?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
        self.deliveriesMapScreen.tabBarItem.selectedImage = self.deliveriesMapScreen.tabBarItem.selectedImage?.withTintColor(UIColor.systemIndigo, renderingMode: .alwaysOriginal)
        
        self.deliveryRoundsScreen.tabBarItem.title = String(localized: "ROUNDS_TEXT")
        self.deliveryRoundsScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        self.deliveryRoundsScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.systemIndigo], for: .selected)
        self.deliveryRoundsScreen.tabBarItem.image = UIImage(systemName: "shippingbox.fill")
        self.deliveryRoundsScreen.tabBarItem.image = self.deliveryRoundsScreen.tabBarItem.image?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
        self.deliveryRoundsScreen.tabBarItem.selectedImage = self.deliveryRoundsScreen.tabBarItem.selectedImage?.withTintColor(UIColor.systemIndigo, renderingMode: .alwaysOriginal)
        
        let navigationController: UITabBarController = UITabBarController()
        navigationController.viewControllers = [
            self.deliveriesMapScreen,
            self.deliveryRoundsScreen,
        ]
        
        navigationController.tabBar.backgroundColor = UIColor.white
        return navigationController
    }
}
