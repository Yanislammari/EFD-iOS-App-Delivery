//
//  NavigationHandler.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 15/02/2025.
//

import UIKit

class NavigationHandler {
    private static var instance: NavigationHandler!
    
    static func getInstance() -> NavigationHandler {
        if self.instance == nil {
            self.instance = NavigationHandler()
        }
        return self.instance
    }
    
    func initNavigation() -> UIViewController {
        let deliveriesMapScreen = DeliveriesMapViewController(nibName: "DeliveriesMapViewController", bundle: nil)
        let deliveryRoundsScreen = DeliveryRoundsViewController(nibName: "DeliveryRoundsViewController", bundle: nil)
        let cameraScreen = CameraViewController(nibName: "CameraViewController", bundle: nil)
       
        deliveriesMapScreen.tabBarItem.title = "Map"
        deliveriesMapScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        deliveriesMapScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.systemIndigo], for: .selected)
        deliveriesMapScreen.tabBarItem.image = UIImage(systemName: "map.fill")
        deliveriesMapScreen.tabBarItem.image = deliveriesMapScreen.tabBarItem.image?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
        deliveriesMapScreen.tabBarItem.selectedImage = deliveriesMapScreen.tabBarItem.selectedImage?.withTintColor(UIColor.systemIndigo, renderingMode: .alwaysOriginal)
        
        deliveryRoundsScreen.tabBarItem.title = "Rounds"
        deliveryRoundsScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        deliveryRoundsScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.systemIndigo], for: .selected)
        deliveryRoundsScreen.tabBarItem.image = UIImage(systemName: "shippingbox.fill")
        deliveryRoundsScreen.tabBarItem.image = deliveryRoundsScreen.tabBarItem.image?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
        deliveryRoundsScreen.tabBarItem.selectedImage = deliveryRoundsScreen.tabBarItem.selectedImage?.withTintColor(UIColor.systemIndigo, renderingMode: .alwaysOriginal)
        
        cameraScreen.tabBarItem.title = "Camera"
        cameraScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        cameraScreen.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.systemIndigo], for: .selected)
        cameraScreen.tabBarItem.image = UIImage(systemName: "camera.fill")
        cameraScreen.tabBarItem.image = cameraScreen.tabBarItem.image?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
        cameraScreen.tabBarItem.selectedImage = cameraScreen.tabBarItem.selectedImage?.withTintColor(UIColor.systemIndigo, renderingMode: .alwaysOriginal)
        
        let navigationController: UITabBarController = UITabBarController()
        navigationController.viewControllers = [
            deliveriesMapScreen,
            deliveryRoundsScreen,
            cameraScreen
        ]
        
        navigationController.tabBar.backgroundColor = UIColor.white
        return navigationController
    }
}
