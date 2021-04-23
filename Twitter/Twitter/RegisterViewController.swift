//
//  RegisterViewController.swift
//  Twitter
//
//  Created by Тамирлан Абаев   on 14.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButton(_ sender: UIButton) {
        let email = emailText.text
        let password = passwordText.text
        guard  email != "", password != "" else {
            return
        }
        Auth.auth().createUser(withEmail: email!, password: password!) {[weak self] (result, error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: nil)
            guard error == nil else {
                self?.showMessage(title: "Error", message: "Some problem occured")
                return
            }
            self?.showMessage(title: "Success", message: "Please verify your email")
        }
    }
    
    func showMessage(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] (UIAlertAction) in
            if title != "Error" {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    

}
