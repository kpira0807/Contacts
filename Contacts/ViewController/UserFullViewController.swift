import UIKit
import Foundation
import SwiftUI

class UserFullViewController: UIViewController {
    
    @IBOutlet weak var userImage: CustomImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.layer.borderColor = UIColor.white.cgColor
        
        title = "\(user?.title.capitalized ?? "") \(user?.firstName ?? "")"
        
        nameLabel.text = "\(user?.firstName ?? "No information") \(user?.lastName ?? "No information")"
        
        emailLabel.text = user?.email
        
        if let imageUrl = URL(string: user?.picture ?? "No information") {
            userImage.loadImage(fromUrl: imageUrl, placeholderImage: "noImage")
        } else {
            userImage.image = UIImage(named: "noImage")
        }
    }
}
