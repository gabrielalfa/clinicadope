//
//  RegisterClienteController.swift
//  MasterApp
//
//  Created by Gabriel Seben on 10/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit

class RegisterClienteController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let plusPhotoButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
    }

}
