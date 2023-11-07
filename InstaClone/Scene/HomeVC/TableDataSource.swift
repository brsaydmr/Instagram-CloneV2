//
//  TableDataSource.swift
//  InstaClone
//
//  Created by Barış Aydemir on 7.11.2023.
//

import UIKit

// MARK: - TableView DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

func numberOfSections(in tableView: UITableView) -> Int {
    return 2
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
        return 1
    }else{
        return viewModel.response?.photos?.photo?.count ?? .zero
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell1", for: indexPath) as! HomeTableViewCell1
        
        return cell
    }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell2", for: indexPath) as! HomeTableViewCell2
        let responseList = viewModel.response?.photos?.photo?[indexPath.row]
        
        cell.userNameLbl.text = responseList?.ownername
        cell.postTimeLbl.text = "1 saat önce"
        cell.commentCountLbl.text = responseList?.title

        if let iconServer = responseList?.iconserver {
            cell.likeCountLbl.text = "\(iconServer) kişi beğendi."
        } else {
            cell.likeCountLbl.text = "0 kişi beğendi."
        }
        
        if let userImageURL = responseList?.buddyIconURL {
            viewModel.fetchImage(from: userImageURL) { imageData in
                if let data = imageData {
                    DispatchQueue.main.async {
                        cell.MainUserPpImg.image = UIImage(data: data)
                        cell.userProfilePictureImg.image = UIImage(data: data)
                    }
                }
            }
        }
        
        if let userPostImageURL = responseList?.urlN {
            viewModel.fetchImage(from: userPostImageURL) { imageData in
                if let data = imageData {
                    DispatchQueue.main.async {
                        cell.userPostImg.image = UIImage(data: data)
                    }
                }
            }
        }
        
        cell.MainUserPpImg.layer.cornerRadius = 24
        cell.userProfilePictureImg.layer.cornerRadius = 24
        
        
        return cell
    }
    
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    if indexPath.section == 0 {
        return 100
    }else{
        return UITableView.automaticDimension
    }
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedPhoto = viewModel.response?.photos?.photo?[indexPath.row]
    performSegue(withIdentifier: "hometodetail", sender: indexPath)
}
}
