//
//  mainTabBarUserController.swift
//  ClinicaDoPe
//
//  Created by Gabriel Seben on 03/05/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

//
//  CustomTabBarController.swift
//  MasterApp
//
//  Created by Gabriel Seben on 06/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarUserController: UITabBarController, UITabBarControllerDelegate {
    
    let user_bool: Bool = false
    
    var userId: String?
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        let index = viewControllers?.index(of: viewController)
//        if index == 2 {
//
//            let layout = UICollectionViewFlowLayout()
//            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
//            let navController = UINavigationController(rootViewController: photoSelectorController)
//
//            present(navController, animated: true, completion: nil)
//
//            return false
//        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        setupViewControllers_user()
    }
    
    
    public func setupViewControllers_user() {
        
        tabBar.backgroundColor = .red
    
        //home
        let userProfileController = templateNavController(unselectedImage: #imageLiteral(resourceName: "camera_white"), selectedImage: #imageLiteral(resourceName: "camera_selected"), rootViewController: UIViewController())
        
        //search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "dados_personal"), selectedImage: #imageLiteral(resourceName: "dados_personal_2"), rootViewController: UIViewController())
        
        
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "list_unselected"), selectedImage: #imageLiteral(resourceName: "list_selected"), rootViewController: UIViewController())
            
        tabBar.tintColor = .black
        
        viewControllers = [userProfileController,
                           searchNavController,
                           likeNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -2, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
}

