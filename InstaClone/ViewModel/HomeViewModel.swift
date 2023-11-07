//
//  HomeViewModel.swift
//  InstaClone
//
//  Created by Barış Aydemir on 3.11.2023.
//

import Foundation

class HomeViewModel {
    // MARK - PROPERTİES
    var response:PhotosResponse?
    var currentPage = 1
    let itemsPerPage = 20
    
    // MARK - FETCH DATA
    func fetch(completion: @escaping () -> Void) {
        NetworkManager.fetchRecentPhotos(page: currentPage, perPage: itemsPerPage) { [weak self] response in
            guard let self = self else { return }

            if let response = response {
                if self.currentPage == 1 {
                    self.response = response
                } else {
                    // Eğer mevcut sayfa 1 değilse, yeni verileri ekleyin
                    self.response?.photos?.photo?.append(contentsOf: response.photos?.photo ?? [])
                }
                self.currentPage += 1
                completion()
            }
        }
    }
    
    // MARK - FETCH IMAGE
    
    func fetchImage(from imageURL: String, completion: @escaping (Data?) -> Void) {
        NetworkManager.shared.fetchImage(with: imageURL) { imageData in
            completion(imageData)
        }
    }
}

