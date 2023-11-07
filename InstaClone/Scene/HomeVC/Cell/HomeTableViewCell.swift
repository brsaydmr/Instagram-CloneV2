//
//  HomeTableViewCell.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import UIKit

class HomeTableViewCell1: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = HomeViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        fetch()
    }

    
    
    // MARK: - Data Fetch
    private func fetch() {
        viewModel.fetch {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
// MARK: - CollectionView DataSource

extension HomeTableViewCell1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.response?.photos?.photo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let responseList = viewModel.response?.photos?.photo?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as! HomeCollectionViewCell

        cell.userNameLbl.text = responseList?.ownername

        if let imageURL = responseList?.buddyIconURL {
            viewModel.fetchImage(from: imageURL) { imageData in
                if let data = imageData {
                    DispatchQueue.main.async {
                        cell.userStoryImg.image = UIImage(data: data)
                    }
                }
            }
        }

        cell.userStoryImg.layer.cornerRadius = 35

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }

}
