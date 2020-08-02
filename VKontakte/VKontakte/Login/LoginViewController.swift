//
//  ViewController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 10/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import QuartzCore

class LoginViewController: UIViewController {
    
    // MARK: -  Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBOutlet weak var borderViewLogin: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    
    
    @IBOutlet weak var borderViewPassword: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        sleep(1)
        guard let login = loginTextField.text,
            let password = passwordTextField.text,
            login == "",
            password == "" else {
                show(message: "Неправильный логин или пароль")
                return
        }
        //   performSegue(withIdentifier: "fromLoginController", sender: nil)
        
        
        let favoriteFriendsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingAnimation")
        //  favoriteFriendsVC.modalTransitionStyle = .crossDissolve
        //  favoriteFriendsVC.modalPresentationStyle = .fullScreen
        //  favoriteFriendsVC.transitioningDelegate = self
        //  self.present(favoriteFriendsVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(favoriteFriendsVC, animated: true)
    }
    
    // MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Войти в аккаунт"
        loginLabel.text = "Логин"
        
        passwordLabel.text = "Пароль"
        
        borderViewLogin.layer.cornerRadius = loginTextField.bounds.height / 2
        borderViewLogin.layer.borderWidth = 1
        borderViewLogin.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.2)
        borderViewLogin.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
        
        loginTextField.attributedPlaceholder = NSAttributedString(string: "Логин или номер телефона", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        loginTextField.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        borderViewPassword.layer.cornerRadius = passwordTextField.bounds.height / 2
        borderViewPassword.layer.borderWidth = 1
        borderViewPassword.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.2)
        borderViewPassword.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        loginButton.setTitle("Войти", for:  UIControl.State.normal)
        loginButton.setTitle("Вхожу...", for: UIControl.State.highlighted)
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.2)
        loginButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
        loginButton.layer.shadowRadius = 4.0
        loginButton.layer.shadowOpacity = 0.6
        loginButton.layer.shadowOffset = CGSize.zero
        loginButton.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        copyrightLabel.text = "by Maxim Safronov"
        copyrightLabel.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0.5)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /* override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     
     navigationController?.setNavigationBarHidden(false, animated: false)
     }*/
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
}
