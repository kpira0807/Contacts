import Foundation
import UIKit

class CustomImage: UIImageView {
    
    func loadImage(fromUrl imageURL: URL, placeholderImage: String) {
        self.image = UIImage(named: placeholderImage)
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }
    
    func createBorder(){
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
