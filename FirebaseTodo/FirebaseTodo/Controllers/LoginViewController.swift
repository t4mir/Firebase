//
//  ViewController.swift
//  FirebaseTodo
//
//  Created by Тамирлан Абаев   on 05.04.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var ref: Firebase.DatabaseReference!
    
    @IBOutlet weak var warnLabel: UILabel!
    {
        didSet {
            warnLabel.alpha = 0
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Firebase.Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
        FirebaseAuth.Auth.auth().addStateDidChangeListener {[weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
            }
        }
            }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func didWarning(withText text:String) {
        
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        }  completion: {[weak self] (Bool) in
            self?.warnLabel.alpha = 0
        }

    }
    
    @objc func kbShow(notification:Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbframeSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbframeSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbframeSize.height, right: 0)
    }
    
    @objc func kbHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text , let password = passwordTextField.text, email != "", password != "" else {
        
            didWarning(withText: "Info is incorect")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error)  in
            if error != nil {
                self!.didWarning(withText: "Error is occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.didWarning(withText: "No such User")
        }
        
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text , let password = passwordTextField.text, email != "", password != "" else {
        
            didWarning(withText: "Info is incorect")
            return
        }
        
        Firebase.Auth.auth().createUser(withEmail: email, password: password) {[weak self] (user, error) in
            guard error == nil, user != nil else  {
                print(error?.localizedDescription as Any)
                return
            }
            
            
            
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email":user?.user.email])
        
    }
    
    
    
}


}
