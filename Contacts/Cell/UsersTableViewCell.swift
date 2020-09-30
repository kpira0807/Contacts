import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: CustomImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var viewBackground: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.layer.borderColor = UIColor.blueButtonColor.cgColor
    }
    
    func setup(with user: User) {
        userNameLabel.text = "\(user.firstName) \(user.lastName)"
        
        if let imageUrl = URL(string: user.picture) {
            
            userImage.loadImage(fromUrl: imageUrl, placeholderImage: "noImage")
        } else {
            userImage.image = UIImage(named: "noImage")
        }
    }
}
