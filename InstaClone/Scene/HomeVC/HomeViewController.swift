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
    var selectedPhoto:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.startAnimating()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.photo = selectedPhoto
            vc.hidesBottomBarWhenPushed = true
        }
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

