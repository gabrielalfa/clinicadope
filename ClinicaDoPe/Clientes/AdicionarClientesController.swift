//
//  ChatLogController.swift
//  MasterApp
//
//  Created by Gabriel Seben on 06/04/2018.
//  Copyright © 2018 Intelecto Alpha. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage

class AdicionarClientesController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var clientes = [Clientes_Model]()
    var user: User?
    var userId: String = ""
    var edit: Bool = false
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.lightGray.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastrar Novo", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        if edit {
            print("Editar Usuario")
            Toast.showPositiveMessage(message: "Salvando Dados...")
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            Storage.storage().reference().child("profile_images").putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                print("Successfully uploaded profile image:", profileImageUrl)
                let parameters = Clientes_Model(username: username, email: email, password: password, profileImageUrl: profileImageUrl)
                
                self.editUser(for: parameters, in: .clientes)
                
            })
            
        }
        else{
            
            print("Adicionar Usuario")
            Toast.showPositiveMessage(message: "Salvando Dados...")
        guard let image = self.plusPhotoButton.imageView?.image else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        
        //let filename = NSUUID().uuidString
        Storage.storage().reference().child("profile_images").putData(uploadData, metadata: nil, completion: { (metadata, err) in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded profile image:", profileImageUrl)
            let parameters = Clientes_Model(username: username, email: email, password: password, profileImageUrl: profileImageUrl)
            
            self.create_Model_2(for: parameters, in: .clientes)
            
        })
    }
}
    
    func create_Model_2<T: Codable>(for encodableObject: T, in collectionReference: FireServices) {
        
        do{
            let json = try encodableObject.toJson(excluding: ["id"])
            reference(to: .clientes).addDocument(data: json)
        }catch{
            print(error)
        }
        
        cancel()
        
    }
    
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FireServices) {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        let parameters: [String: Any] = ["email": email,
                                         "username": username,
                                         "password": password]
        
        reference(to: .clientes).addDocument(data: parameters)
        
        cancel()
        
    }
    
    func reference(to collectionReference: FireServices) -> CollectionReference{
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    @IBAction func cancel() {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
            print("cancel")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Cadastre novos Clientes  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Listagem", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        if !(userId.isEmpty) {
            print("Buscar Dados para editar Cliente")
            signUpButton.setTitle("Editar Cadastro", for: .normal)
            edit = true
            fetchUser()
        }
        
        
    }
    
    
    func editUser<T: Encodable & Indentifiable>(for encodableObject: T,in collectionReference: FireServices)  {
        
        do{
            let json = try encodableObject.toJson(excluding: ["id"])
            //guard let id = encodableObject.id else { throw MyError.encodingError }
            reference(to: .clientes).document(userId).setData(json)
            cancel()
        }catch{
            print(error)
        }
    }
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    fileprivate func fetchUser() {
        
        let uid = userId
        handleTextInputChange()
        
        Database.fetchUserWithUID_Clientes(uid: uid) { (user) in
            self.user = user
            //self.navigationItem.title = self.user?.username
            self.emailTextField.text = self.user?.email
            self.usernameTextField.text = self.user?.username
            self.passwordTextField.text = self.user?.password
            

            if (self.user?.profileImageUrl.isEmpty)!{
                self.plusPhotoButton.setImage(#imageLiteral(resourceName: "user").withRenderingMode(.alwaysOriginal), for: .normal)
                self.signUpButton.isEnabled = true
                self.signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            }else{
                
                self.activityIndicator.center = self.plusPhotoButton.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                self.plusPhotoButton.addSubview(self.activityIndicator)
                
                self.activityIndicator.anchor(top: self.view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
                
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                
                self.activityIndicator.startAnimating()
                
                //self.plusPhotoButton.setImage(#imageLiteral(resourceName: "user").withRenderingMode(.alwaysOriginal), for: .normal)
                
                let URL_IMAGE = URL(string: self.user?.profileImageUrl as! String)


//                let textImage = UIImage(named: self.user?.profileImageUrl as! String)
//                self.plusPhotoButton.setImage(URL_IMAGE.withRenderingMode(.alwaysOriginal), for: .normal)

                let session = URLSession(configuration: .default)

                //creating a dataTask
                let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in

                    //if there is any error
                    if let e = error {
                        //displaying the message
                        print("Error Occurred: \(e)")

                    } else {
                        //in case of now error, checking wheather the response is nil or not
                        if (response as? HTTPURLResponse) != nil {

                            //checking if the response contains an image
                            if let imageData = data {

                                //getting the image
                                let image = UIImage(data: imageData)

                                //displaying the image
                                //self.uiImageView.image = image
                                self.plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                                self.plusPhotoButton.layer.cornerRadius = self.plusPhotoButton.frame.width/2
                                self.plusPhotoButton.layer.masksToBounds = true
                                self.plusPhotoButton.layer.borderColor = UIColor.lightGray.cgColor
                                self.plusPhotoButton.layer.borderWidth = 3
                                

                            } else {
                                print("Image file is currupted")
                            }
                        } else {
                            print("No response from server")
                        }
                        self.activityIndicator.stopAnimating()
                        self.signUpButton.isEnabled = true
                        self.signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                    }
            }
                
                getImageFromUrl.resume()
               
          }
        }
        
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
}









