//
//  User.swift
//  Twitter
//
//  Created by Тамирлан Абаев   on 19.04.2021.
//

import Foundation
import Firebase
struct User {
    let uid: String
    let email: String
    
    init(user:FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
