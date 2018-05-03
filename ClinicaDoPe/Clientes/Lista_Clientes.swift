//
//  TableTest.swift
//  ClinicaDoPe
//
//  Created by Gabriel Seben on 21/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage

class Lista_ClientesController: UITableViewController, UISearchBarDelegate {
    
    
    let cellId = "cellId"
    var clientes = [Clientes_Model]()
    
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Username or Email"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    
    
    let buttonCancel: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Lista Clientes"
        setupNavigationItems()
        
        read_Clientes(from: .clientes, returning: Clientes_Model.self) { (clientes ) in
            self.clientes = clientes
            self.tableView?.reloadData()
        }
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.alwaysBounceVertical = true
        
        self.tableView.register(ClienteCell_teste.self, forCellReuseIdentifier: cellId)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
    }
    
    func read_Clientes<T: Decodable>(from collectionReference: FireServices, returning objectType: T.Type, completion: @escaping ([T]) -> Void ) {
        
        
        reference(to: .clientes).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            
            do{
                var objects = [T]()
                for document in snapshot.documents{
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
                
            }catch{
                print(error)
            }
            
        }
    }
    
    
    func reference(to collectionReference: FireServices) -> CollectionReference{
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            read_Clientes(from: .clientes, returning: Clientes_Model.self) { (clientes ) in
                self.clientes = clientes
            }
        } else {
            self.clientes = clientes.filter({ (clientes) -> Bool in
                return clientes.username.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.tableView?.reloadData()
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if let count =  clientes.count {
        //            return clientes.count
        //        }
        return clientes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ClienteCell_teste
//
//        cell.nameLabel.text = clientes[indexPath.row].username
//        cell.messageLabel.text = clientes[indexPath.row].email
//
//        cell.profileImageView.image = UIImage(named: "user")
//
//        if let profileImageUrl = clientes[indexPath.row].profileImageUrl {
//            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//        }
//
//        //cell.profileImageView.image = UIImage(named: clientes[indexPath.row].profileImageUrl)
//
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ClienteCell_teste
        
        let user = clientes[indexPath.row]
        cell.nameLabel.text = user.username
        cell.messageLabel.text = user.email
        
        cell.profileImageView.image = UIImage(named: "user")
        
        if !user.profileImageUrl.isEmpty{
            print(user.profileImageUrl)
             cell.profileImageView.loadImageUsingCacheWithUrlString(user.profileImageUrl)
        }else {
            
        }
        
        return cell
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
       
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete User", style: .destructive, handler: { (_) in
            
            let user = self.clientes[indexPath.row]
            self.deleteSelectdUser(user, in: .clientes)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if !isEditing{
            let layout = UICollectionViewFlowLayout()
            let mainTab = MainTabBarUserController()
            let userProfileController = UserProfileController(collectionViewLayout: layout)
            let navController = UINavigationController()
            let user = self.clientes[indexPath.row]
            let id = user.id
            userProfileController.userId = id
            mainTab.userId = id
            mainTab.addChildViewController(userProfileController)
            navController.addChildViewController(mainTab)
            
            navigationController?.showDetailViewController(mainTab, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    
    func setupNavigationItems() {
        
        //        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handlePlus))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_unselected").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        
        
    }
    
    @objc func handlePlus(){
        let signUpController = AdicionarClientesController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func handleSearch(){
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.title = ""
        navigationController?.navigationBar.addSubview(searchBar)
        navigationController?.navigationBar.addSubview(buttonCancel)
        searchBar.isHidden = false
        buttonCancel.isHidden = false
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: buttonCancel.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        buttonCancel.anchor(top: navBar?.topAnchor, left: nil, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        buttonCancel.addTarget(self, action: #selector(handleCancerlSearch), for: .touchUpInside)
    }
    
    @objc func handleCancerlSearch(){
        
        searchBar.isHidden = true
        buttonCancel.isHidden = true
        navigationItem.title = "Lista de Clientes"
        setupNavigationItems()
        
        read_Clientes(from: .clientes, returning: Clientes_Model.self) { (clientes) in
            self.clientes = clientes
            self.tableView?.reloadData()
        }
        
        searchBar.text = nil
        
    }
    
    
    
    
    
    func deleteSelectdUser<T: Indentifiable>(_ identifiableObject: T,in collectionReference: FireServices)  {
        
        do{
            guard let id = identifiableObject.id else { throw MyError.encodingError }
            reference(to: .clientes).document(id).delete()
            
        }catch{
            print(error)
        }
    }
    
    
    
    
    
}


class ClienteCell_teste: BaseCell_teste {
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 259/255, alpha: 0.7) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var cliente: Clientes_Model?{
        didSet{
            nameLabel.text  = cliente?.username
            
            //            if let profileImageName = cliente?.profileImageName
            //            {
            //                profileImageView.image = UIImage(named: profileImageName);
            //                hasReadImageView.image = UIImage(named: profileImageName);
            //            }
            
            messageLabel.text = cliente?.email
            
            //            if let date = cliente?.date{
            //
            //                let dateFormatter = DateFormatter()
            //                dateFormatter.dateFormat = "h:mm a"
            //
            //                let elapsedTimeInSecond = NSDate().timeIntervalSince(date)
            //
            //                let secondInDays: TimeInterval = 60 * 60 * 24
            //
            //
            //                if elapsedTimeInSecond > 7 * secondInDays{
            //                    dateFormatter.dateFormat = "dd/MM/yy"
            //                }else if elapsedTimeInSecond > secondInDays{
            //                    dateFormatter.dateFormat = "EEE"
            //                }
            //
            //                timeLabel.text = dateFormatter.string(from: date as Date)
            //
            //            }
            
        }
    }
    
    
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineVew: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome do Cliente"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Alguma mensagem do cliente ou contato..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "18:00"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //imageView.isHidden = true
        imageView.image = UIImage(named: "unchecked_box")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    
    override func setupViews(){
        
        //addSubview(checkBoxImageView)
        addSubview(profileImageView)
        addSubview(dividerLineVew)
        
        setupContainerView()
        
        //profileImageView.image = UIImage(named: "user")
        hasReadImageView.image = UIImage(named: "user")
        
        //addConstraintWithFormat("H:|-12-[V0(68)]|", views: profileImageView)
        
        // addConstraintWithFormat("V:[V0(68)]", views: profileImageView)
        //addConstraintWithFormat("V:[V0(24)]", views: checkBoxImageView)
        
        //                addConstraintWithFormat("H:|-12-[V0(68)]-12-|", views: checkBoxImageView)
        //                addConstraintWithFormat("V:[V0(68)]", views: checkBoxImageView)
        
        addConstraintWithFormat("H:|-12-[V0(68)]|", views: profileImageView)
        addConstraintWithFormat("V:[V0(68)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        //addConstraint(NSLayoutConstraint(item: checkBoxImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        addConstraintWithFormat("H:|-82-[V0]|", views: dividerLineVew)
        addConstraintWithFormat("V:[V0(1)]|", views: dividerLineVew)
        
    }
    
    private func setupContainerView(){
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintWithFormat("H:|-90-[V0]|", views: containerView)
        addConstraintWithFormat("V:[V0(50)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintWithFormat("H:|[V0][V1(80)]-12-|", views: nameLabel, timeLabel)
        containerView.addConstraintWithFormat("V:|[V0][V1(24)]|", views: nameLabel, messageLabel)
        containerView.addConstraintWithFormat("H:|[V0]-8-[V1(20)]-12-|", views: messageLabel, hasReadImageView)
        containerView.addConstraintWithFormat("V:|[V0(24)]|", views: timeLabel)
        containerView.addConstraintWithFormat("V:[V0(20)]|", views: hasReadImageView)
        
        
    }
    
    private func setupBloco(){
        let containerView = UIView()
        addSubview(containerView)
        containerView.backgroundColor = UIColor.green
        
        addConstraintWithFormat("H:|-90-[V0]|", views: containerView)
        addConstraintWithFormat("V:[V0(50)]", views: containerView)
        
    }
    
    
}


class BaseCell_teste: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
    }
}

