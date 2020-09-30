import Foundation
import Alamofire
import SwiftyJSON

class JSONLoading {
    var lastPage = 0
    var downloadResultLimit = 0
    var downloadResultOffset = 0
    var downloadResultTotal = 0
    let networksManager = NetworksManager()
    
    func downloadData(from urlString: String, pageNumber: Int = 0, limit: Int = 20, completion: @escaping (Data?) -> Void) {
        let request = AF.request(urlString, parameters: ["page": "\(pageNumber)", "limit": "\(limit)"], headers: ["app-id": networksManager.appId])
        request.responseJSON { (data) in
            if let data = data.data, let json = try? JSON(data: data) {
                self.downloadResultLimit = json["limit"].int ?? 0
                self.downloadResultOffset = json["offset"].int ?? 0
                self.downloadResultTotal = json["total"].int ?? 0
                self.lastPage = json["page"].int ?? 0
            }
            completion(data.data)
        }
    }
}
