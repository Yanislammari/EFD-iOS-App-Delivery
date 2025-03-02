//
//  LoginViewController.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 12/02/2025.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgottenPasswordLabel: UILabel!
    @IBOutlet weak var applyForAnAccountLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var forgotPasswdButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var passwordSendNewEmail: UIButton!
    
    var authService: AuthService {
        return AuthService.getInstance()
    }
    
    var deliveryManService: DeliveryManService {
        return DeliveryManService.getInstance()
    }
    
    var toastHandler: ToastHandler {
        return ToastHandler.getInstance()
    }
    
    var navigationHandler: NavigationHandler {
        return NavigationHandler.getInstance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.isHidden = true
        passwordSendNewEmail.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.authService.message = nil
        self.authService.token = nil
        emailField.isHidden = true
        passwordSendNewEmail.isHidden = true
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
            self.toastHandler.showToast(message: "All fields are required", in: self)
            return
        }
            
        self.authService.login(email: emailTextField.text!, password: passwordTextField.text!) {
            DispatchQueue.main.async {
                if self.authService.message != nil && self.authService.token == nil {
                    self.toastHandler.showToast(message: self.authService.message!, in: self)
                }
                else if let token = self.authService.token {
                    self.authService.decodeToken(token: token) { userId in
                        self.deliveryManService.getDeliveryManById(id: userId, token: token) { deliveryMan in
                            self.deliveryManService.deliveryManConnected = deliveryMan
                            DispatchQueue.main.async {
                                self.navigationController?.pushViewController(self.navigationHandler.initNavigation(), animated: true)
                            }
                        }
                    }
                }
                else {
                    self.toastHandler.showToast(message: "Error servor", in: self)
                }
            }
        }
    }
    @IBAction func forgotPasswd(_ sender: Any) {
        emailField.isHidden = false
        forgotPasswdButton.isHidden = true
        welcomeLabel.isHidden = true
        passwordSendNewEmail.isHidden = false
    }
    
    @IBAction func sendNewPasswd(_ sender: Any) {
        
        authService.getNewPasswd(email: emailField.text ?? ""){
            DispatchQueue.main.async {
                self.emailField.isHidden = true
                self.forgotPasswdButton.isHidden = false
                self.welcomeLabel.isHidden = false
                self.passwordSendNewEmail.isHidden = true
            }
        }
    }
}
