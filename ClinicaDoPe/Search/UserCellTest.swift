
import UIKit

class UserCellTest: UICollectionViewCell {
    
    var user: User? {
        didSet {
            nameLabel.text = user?.username
            messageLabel.text = user?.uid
            
            //guard let profileImageUrl = user?.profileImageUrl else { return }
            
           // profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 34
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
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
        label.text = "00:00"
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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)
        addSubview(dividerLineVew)

        setupContainerView()

        profileImageView.image = UIImage(named: "user")
        hasReadImageView.image = UIImage(named: "user")

        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 18, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
       

        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        addConstraintWithFormat("H:|-82-[V0]|", views: dividerLineVew)
        addConstraintWithFormat("V:[V0(1)]|", views: dividerLineVew)

     }
    
//    func setupViews(){
//
//        addSubview(profileImageView)
//        addSubview(dividerLineVew)
//
//        setupContainerView()
//
//        profileImageView.image = UIImage(named: "user")
//        hasReadImageView.image = UIImage(named: "user")
//
//        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
//        profileImageView.layer.cornerRadius = 50 / 2
//        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//
//        addConstraintWithFormat("H:|-82-[V0]|", views: dividerLineVew)
//        addConstraintWithFormat("V:[V0(1)]|", views: dividerLineVew)
//
//    }
//
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



