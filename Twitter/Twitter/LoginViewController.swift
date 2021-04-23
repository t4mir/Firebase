//
//  LoginViewController.swift
//  Twitter
//
//  Created by Тамирлан Абаев   on 14.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {
    
    var current_user: User?

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         current_user = Auth.auth().currentUser

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        current_user = Auth.auth().currentUser
        if current_user != nil && current_user!.isEmailVerified {
            self.performSegue(withIdentifier: "TweetsSegue", sender: nil)
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        let email = emailText.text
        let password = passwordText.text
        guard email != "",password != "" else { return }
        Auth.auth().signIn(withEmail: email!, password: password!) {[weak self] (result, error) in
            if error == nil {
                if Auth.auth().currentUser!.isEmailVerified {
                    
                    self?.performSegue(withIdentifier: "TweetsSegue", sender: nil)
                    
//                    self?.showMessage(title: "OK", message: "Your email is  verified")
                }
                else {
                    self?.showMessage(title: "Warning", message: "Your email is not verified")
                    
                }
            } else {
                
            }
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
    

//    func goToMainPage() {
//        let storybord = UIStoryboard(name: "Main", bundle: Bundle.main)
//        if let mainPage = storybord.instantiateViewController(identifier: "TweetsViewController") as? MainPageViewController {
//            mainPage.modalPresentationStyle = .fullScreen
//            present(mainPage, animated: true, completion: nil)
//        }
//    }

}
