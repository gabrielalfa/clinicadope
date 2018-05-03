//
//  ViewController.swift
//  MasterApp
//
//  Created by Gabriel Seben on 31/03/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage


class ClientesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    //var messages: [Message]?
    
    var clientes: [Clientes_Model]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
    
    let bloco: UICollectionViewCell = {
        let imageView = UICollectionViewCell()
        imageView.backgroundColor = UIColor.red
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Lista Clientes"
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        collectionView?.register(ClientesHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ClienteCell.self, forCellWithReuseIdentifier: cellId)
        
        //setupData()
        
        setupNavigationItems()
        
        read_Clientes(from: .clientes, returning: Clientes_Model.self) { (clientes) in
            self.clientes = clientes
            self.collectionView?.reloadData()
        }
        //update_Clientes()
        //delete_Cliente()
        
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.collectionView?.allowsMultipleSelection = editing
        let indexPaths: [NSIndexPath] = self.collectionView?.indexPathsForVisibleItems as! [NSIndexPath]
        
        for indexPath in indexPaths{
            self.collectionView?.deselectItem(at: indexPath as IndexPath, animated: false)
            let cell: ClienteCell = (self.collectionView?.cellForItem(at: indexPath as IndexPath) as? ClienteCell)!
            cell.editing = editing
        }
        
        if  editing{
            for indexPath in indexPaths{
                let cli_ident = clientes![indexPath.row]
                
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectdItem2(sender:  cli_ident in: .clientes)))
                
                
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(self.deleteSelectdItem2(cli_ident, in: .clientes)))
//
                
                
            }
            
        }
        else{
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
 
 func deleteSelectdItem2<T: Indentifiable>(_ identifiavleObject: T,in collectionReference: FireServices)  {
        
        do{
            
            guard let id = identifiavleObject.id else { throw MyError.encodingError }
            print(id)
            
            
        }catch{
            print(error)
        }
    
    
    }
    
    @objc func deleteSelectdItemAction(_ sender: AnyObject?){
        
       
//        if  let IndexPaths = collectionView?.indexPathsForSelectedItems {
//            for IndexPath in IndexPaths {
//                if let cell = collectionView?.cellForItem(at: IndexPath) as? ClienteCell{
//
//                    let customer = clientes![IndexPath.row]
//
//                    let idToDelete = customer.id
//
//                    print(customer)
//                    print(idToDelete)
//
//
//                    //print(cell)
//                }
//            }
//        }
        
        //reference(to: .clientes).document("SrZr1cg0LT1nSPiWBp7E").delete()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
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
    
    
    
    func delete_Cliente() {
        
        let IndexPaths = collectionView?.indexPathsForSelectedItems
        
        //let cli = clientes[IndexPath.init(row: <#T##Int#>, section: <#T##Int#>)]
        
        reference(to: .clientes).document("SrZr1cg0LT1nSPiWBp7E").delete()
        
    }
    
    func update_Clientes<T: Encodable & Indentifiable>(for encodableObject: T, in collectionReference: FireServices) {
        
        
        do{
            
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id = encodableObject.id else { throw MyError.encodingError }
            
            print(id)
            
            reference(to: .clientes).document(id).setData(["password": 12345678, "username": "Seben Fotografia", "email": "Seben.fotografia@gmail.com"])
            
        }catch {
            print(error)
        }
        
        
        
    }
    
    func reference(to collectionReference: FireServices) -> CollectionReference{
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func setupNavigationItems() {
        
        //        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handlePlus))
    }
    
    @objc func handlePlus(){
        let signUpController = AdicionarClientesController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count =  clientes?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ClienteCell
        
        if  let cliente = clientes?[indexPath.item]{
            cell.cliente = cliente
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let layout = UICollectionViewFlowLayout()
        //        let controller = ChatLogController(collectionViewLayout: layout)
        //        controller.cliente = messages?[indexPath.item].cliente
        //        navigationController?.pushViewController(controller, animated: true)
        
        // print(clientes?[indexPath.item].email as Any)
        
        if !isEditing{
            let layout = UICollectionViewFlowLayout()
            let userProfileController = UserProfileController(collectionViewLayout: layout)
            navigationController?.pushViewController(userProfileController, animated: true)
        }
        
        
    }
    
}

class ClienteCell: BaseCell {
    
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
    
    let nameLabel: UILabel = {
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
    
    
    var editing: Bool = false
    
    override var isSelected: Bool {
        didSet{
            if editing{
                //                self.checkBoxImageView.image = UIImage(named: isSelected ? "checked_box" : "unchecked_box")
                
                self.checkBoxImageView.image = UIImage(named: isSelected ? "checked_box" : "unchecked_box")
                
                checkBoxImageView.isHidden = false
                
            }
            else{
                checkBoxImageView.isHidden = true
            }
        }
    }
    
    
    
    override func setupViews(){
        
        addSubview(checkBoxImageView)
        //addSubview(profileImageView)
        addSubview(dividerLineVew)
        
        setupContainerView()
        
        profileImageView.image = UIImage(named: "user")
        hasReadImageView.image = UIImage(named: "user")
        
        //        addConstraintWithFormat("H:|-12-[V0(24)][V1(68)]|", views: checkBoxImageView, profileImageView)
        //
        //        addConstraintWithFormat("V:[V0(68)]", views: profileImageView)
        //        addConstraintWithFormat("V:[V0(24)]", views: checkBoxImageView)
        
        //        addConstraintWithFormat("H:|-12-[V0(68)]-12-|", views: checkBoxImageView)
        //        addConstraintWithFormat("V:[V0(68)]", views: checkBoxImageView)
        
        //addConstraintWithFormat("H:|-12-[V0(68)]|", views: profileImageView)
        // addConstraintWithFormat("V:[V0(68)]", views: profileImageView)
        
        //addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: checkBoxImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
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

extension UIView{
    
    func addConstraintWithFormat(_ format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "V\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
    func centerCotainer(views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "V\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraint(NSLayoutConstraint(item: viewsDictionary, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
    }
}


