//
//  User.swift
//  FirebaseTodo
//
//  Created by Тамирлан Абаев   on 14.04.2021.
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
