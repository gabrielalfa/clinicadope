//
//  ChatLogController.swift
//  MasterApp
//
//  Created by Gabriel Seben on 06/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//

import UIKit
import CoreData



class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    private let cellId = "cellId"
    
    var cliente: Cliente?{
        didSet{
            navigationItem.title = cliente?.name
            
            //messages = cliente?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
        }
    }
    
    var messages: [Message]?
    
    let messageImputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Adicionar Mensagem..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        
        let message =  ClientesController.createMessagetext(text: inputTextField.text!, cliente: cliente!, minutesAgo: 0, context: context, isSender: true)
        
        do{
            try context.save()
            messages?.append(message)
            
            let item = messages!.count - 1
            let insertIndexPath = NSIndexPath(item: item, section: 0)
            
            collectionView?.insertItems(at: [insertIndexPath as IndexPath])
            collectionView?.scrollToItem(at: insertIndexPath as IndexPath, at: .bottom, animated: true)
            inputTextField.text = nil
            
        }catch let err{
            print(err)
        }
        
        
    }
    
    var bottonConstraint: NSLayoutConstraint?
    
    @objc private func simulate(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let message = ClientesController.createMessagetext(text: "Here`s  a text message fill good message cliente.... whait", cliente: cliente!, minutesAgo: 1, context: context)
        
        do{
            try context.save()
            messages?.append(message)
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
            
            if let item = messages?.index(of: message){
                let receivingIndexPath = NSIndexPath(item: item, section: 0)
                collectionView?.insertItems(at: [receivingIndexPath as IndexPath])
            }
            
            
        }catch let err{
            print(err)
        }
        
        
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "cliente.name = %@", self.cliente!.name!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try fetchedResultsController.performFetch()
            
            print(fetchedResultsController.sections?[0].numberOfObjects)
            
        }catch let err {
            print(err)
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageImputContainerView)
        view.addConstraintWithFormat("H:|[V0]|", views: messageImputContainerView)
        view.addConstraintWithFormat("V:[V0(48)]", views: messageImputContainerView)
        
        bottonConstraint = NSLayoutConstraint(item: messageImputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottonConstraint!)
        
        
        setuImputComponents()
        
        
        
    }
    
    
    @objc func handKeyboardNotification(notification: Notification){
        if let userInfo = notification.userInfo{
            let keyboardSize:CGSize = ((userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size)!
            bottonConstraint?.constant = -keyboardSize.height
            
            UIView.animate(withDuration: 3.0 , delay: 0.25, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                
                let indexPath = NSIndexPath(item: self.messages!.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            })
        }
    }
    
    @objc func handKeyboardNotificationHide(notification: Notification){
        bottonConstraint?.constant =  0
        UIView.animate(withDuration: 3.0 , delay: 0.25, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handKeyboardNotificationHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private func setuImputComponents(){
        
        let topBoardView = UIView()
        topBoardView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageImputContainerView.addSubview(inputTextField)
        messageImputContainerView.addSubview(sendButton)
        messageImputContainerView.addSubview(topBoardView)
        messageImputContainerView.addConstraintWithFormat("H:|-8-[V0][V1(60)]|", views: inputTextField, sendButton)
        messageImputContainerView.addConstraintWithFormat("V:|[V0]|", views: inputTextField)
        messageImputContainerView.addConstraintWithFormat("V:|[V0]|", views: sendButton)
        
        messageImputContainerView.addConstraintWithFormat("H:|[V0]|", views: topBoardView)
        messageImputContainerView.addConstraintWithFormat("V:|[V0(0.5)]", views: topBoardView)
        
        //let indexPath = NSIndexPath(item: self.messages!.count - 1, section: 0)
        //self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchedResultsController.sections?[0].numberOfObjects{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item],  let messageText = message.text,  let profileImageName = message.cliente?.profileImageName {
            
            cell.profileImageView.image = UIImage(named: profileImageName   )
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if !message.isSender {
                cell.messageTextView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textbundleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                cell.profileImageView.isHidden = false
                
                cell.textbundleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
                
            }else{
                
                //celular de mensgem enviada
                
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textbundleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                cell.profileImageView.isHidden = true
                
                cell.textbundleView.backgroundColor = UIColor(red: 0, green: 135/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = UIColor.white
                
            }
            
            
            
            
        }
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text{
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        //textView.text = "Sample Message"
        return textView
    }()
    
    
    let textbundleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
        imageView.tintColor  = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(textbundleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintWithFormat("H:|[V0(30)]", views: profileImageView)
        addConstraintWithFormat("V:[V0(30)]|", views: profileImageView)
        
//        textbundleView.addSubview(bubbleImageView)
//        textbundleView.addConstraintWithFormat("H:|[V0]|", views: bubbleImageView)
//        textbundleView.addConstraintWithFormat("V:|[V0]|", views: bubbleImageView)
        
        
    }
}
