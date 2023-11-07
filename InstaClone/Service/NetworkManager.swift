//
//  NetworkManager.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//
import Foundation
import Alamofire

struct NetworkManager {
    static let shared = NetworkManager()
    
    func fetchImage(with url: String?, completion: @escaping (Data) -> Void) {
        guard let urlString = url, let url = URL(string: urlString) else { return }
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    static func fetchRecentPhotos(page: Int, perPage: Int, completion: @escaping (PhotosResponse?) -> Void) {
        let urlString = API.getRecentPhotosURL(page: page, perPage: perPage)
        let parameters = API.getRecentPhotosParameters(page: page, perPage: perPage)
        
        AF.request(urlString, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(PhotosResponse.self, from: data)
                    completion(decodedData)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            case .failure(let error):
                debugPrint(error)
                completion(nil)
            }
        }
    }
}

