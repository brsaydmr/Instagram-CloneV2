//
//  SearchViewController.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - PROPERTIES
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel:SearchViewModel = SearchViewModel()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var refreshControl = UIRefreshControl()
    var isLoading = false
    var selectedPhoto:Photo?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupUI()
        fetch()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = viewModel.createLayout()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupSearchController()
    }
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.photo = selectedPhoto
            vc.hidesBottomBarWhenPushed = true
        }
    }
    
    // MARK: - SetupSeacrhController

    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        
        search.searchBar.becomeFirstResponder()
    }
    
    func searchPhotos(with text: String) {
        activityIndicator.startAnimating()
        viewModel.searchPhotos(with: text) { success, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if success {
                    self.collectionView.reloadData()
                } else {
                    // Handle error, show alert or update UI accordingly
                    if let error = error {
                        print("Search error: \(error)")
                        // Show an alert or update UI to inform the user about the error
                    }
                }
            }
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            searchPhotos(with: text)
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
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            // Eğer kullanıcı en alta ulaştıysa, daha fazla veri çek
            fetch()
        }
    }
    
    // MARK: - Refresh Control
    @objc private func refreshData() {
        fetch()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

