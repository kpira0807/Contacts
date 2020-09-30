import Foundation
import SwiftyJSON

class UserLoading {
    func decodeUsers(from data: Data) -> [User] {
        var user = [User]()
        if let json = try? JSON(data: data) {
            let userJson = json["data"]
            for (_, dict) in userJson {
                decodeUser(fromJson: dict) { users in
                    user.append(users)
                }
            }
            return user
        } else {
            return user
        }
    }
    
    private func decodeUser(fromJson json: JSON, completion: @escaping (User) -> Void) {
        let imageUrlString = json["picture"].stringValue.replacingOccurrences(of: "\\", with: "")
        let user = User(id: json["id"].stringValue, title: json["title"].stringValue, firstName: json["firstName"].stringValue, lastName: json["lastName"].stringValue, email: json["email"].stringValue, picture: imageUrlString)
        completion(user)
    }
}
