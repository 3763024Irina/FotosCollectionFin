import Alamofire
import SwiftyJSON

struct PixabayAPI {
    static func fetchPhotos(query: String, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PIXABAY_API_KEY") as? String else {
            completion(.failure(NSError(domain: "PixabayAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Key is missing in Info.plist"])))
            return
        }

     
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "PixabayAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode query"])))
            return
        }
        let urlString = "https://pixabay.com/api/?key=\(apiKey)&q=\(encodedQuery)&image_type=photo&per_page=20&page=\(page)"
        
        print("Request URL: \(urlString)")

      
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photos = json["hits"].arrayValue.map { photo in
                    let photoURL = photo["webformatURL"].stringValue
                    return Photo(url: photoURL)
                }
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
