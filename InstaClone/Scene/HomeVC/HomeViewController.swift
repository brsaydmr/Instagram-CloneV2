//
//  ViewController.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var refreshControl = UIRefreshControl()
    var viewModel:HomeViewModel = HomeViewModel()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.startAnimating()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Refresh Control
    @objc private func refreshData() {
        fetch()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }

    // MARK: - FETCH
    private func fetch() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        viewModel.fetch { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

    // MARK: - ScrollView Delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navigationController = self.navigationController {
            if scrollView.contentOffset.y > 0 {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            fetch()
        }
    }
}
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
        print(indexPath)
    }
}

