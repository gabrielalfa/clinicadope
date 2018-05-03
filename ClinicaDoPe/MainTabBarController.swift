//
//  CustomTabBarController.swift
//  MasterApp
//
//  Created by Gabriel Seben on 06/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let user_bool: Bool = false
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        
        
       
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.delegate = self
        
        
       if Auth.auth().currentUser == nil {
           //show if not logged in
           DispatchQueue.main.async {
               let loginController = LoginController()
               let navController = UINavigationController(rootViewController: loginController)
               self.present(navController, animated: true, completion: nil)
           }

           return
       }
    
        
        setupViewControllers()
    
        
    }
    
    
    func setupViewControllers() {
        
        
        
        //home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "user_icon"), selectedImage: #imageLiteral(resourceName: "user_icon_selected"), rootViewController: UserSelfController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //user profile
        //let layout = UICollectionViewFlowLayout()
        //let layout = UITableView()
        let userProfileController = Lista_ClientesController()
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "list_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "list_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           userProfileNavController,
                           likeNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func setupViewControllers_user() {
        
        tabBar.backgroundColor = .black
        
        //home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "camera_white"), selectedImage: #imageLiteral(resourceName: "camera_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "dados_personal"), selectedImage: #imageLiteral(resourceName: "dados_personal_2"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
       
        
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "list_unselected"), selectedImage: #imageLiteral(resourceName: "list_selected"), rootViewController: UserSelfController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           likeNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
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
