//
//  FirebaseUtils.swift
//  ClinicaPe
//
//  Created by Gabriel Seben on 14/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import Foundation
import Firebase
let db = Firestore.firestore()

extension Database {
    
    static func fetchUserWithUID_Clientes(uid: String, completion: @escaping (User) -> ()) {
        
        db.collection("clientes").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                print("Current data: \(String(describing: document.data()))")
                let user = User(uid: uid, dictionary: document.data() as! [String: Any])
                completion(user)
        }
    }

    
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)

        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    
}
