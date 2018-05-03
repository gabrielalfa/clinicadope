//
//  User.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 4/11/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    let email: String
    let password: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
        self.email = dictionary["email"]  as? String ?? ""
        self.password = dictionary["password"]  as? String ?? ""
    }
}
