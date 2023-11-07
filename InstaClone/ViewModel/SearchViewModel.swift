//
//  SearchViewModel.swift
//  InstaClone
//
//  Created by Barış Aydemir on 4.11.2023.
//

import Foundation
import UIKit

class SearchViewModel {
    // MARK - PROPERTİES
    var response:PhotosResponse?
    var currentPage = 1
    let itemsPerPage = 20
    
    
    
    func searchPhotos(with text: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7dd89640e14551c5df5f7bbae1f68223&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else {
            completion(false, "Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            do {
                let response = try JSONDecoder().decode(PhotosResponse.self, from: data)
                self.response = response // assuming 'response' is a property in your ViewModel
                completion(true, nil)
            } catch {
                completion(false, error.localizedDescription)
            }
        }.resume()
    }

    
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
    
    // MARK - CreateLayout

    func createLayout() -> UICollectionViewCompositionalLayout {
       let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
       
       let fullItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
       let verticalGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: fullItem, count: 2)
       
       let horizontalGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.6), items: [item, verticalGroup])
       
       let mainItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(0.4), spacing: 1)
       let mainGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [mainItem, horizontalGroup])
       
       let section = NSCollectionLayoutSection(group: mainGroup)
       
       // return
       return UICollectionViewCompositionalLayout(section: section)
   }
}
