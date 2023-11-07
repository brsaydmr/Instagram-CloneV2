//
//  CollectionDataSource.swift
//  InstaClone
//
//  Created by Barış Aydemir on 7.11.2023.
//

import UIKit
// MARK: - CollectionDataSource

extension SearchViewController: UICollectionViewDelegate,UICollectionViewDataSource {
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.response?.photos?.photo?.count ?? 0
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let photoList = viewModel.response?.photos?.photo?[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
    
    if let userPostImageURL = photoList?.urlN {
        viewModel.fetchImage(from: userPostImageURL) { imageData in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.searchImg.image = UIImage(data: data)
                }
            }
        }
    }
    return cell
}
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedPhoto = viewModel.response?.photos?.photo?[indexPath.row]
    performSegue(withIdentifier: "searchtodetail", sender: indexPath)
    print(indexPath)
}
}
