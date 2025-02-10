//
//  PicsumHomeViewController.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import UIKit

class PicsumHomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = PicsumViewModel()
    private var isShowingAlert = false
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let loadingFooter: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        label.text = "Loading..."
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configActivityIndicator()
        configTableView()
        configSearchBar()
        viewModel.fetchImageList()
    }
    
    override func binds() {
        viewModel.onFinishLoad = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.loadingFooter.isHidden = true
            }
        }
        
        viewModel.onSearchComplete = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.onErrorFetching = { [weak self] error in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.loadingFooter.isHidden = true
                self.tableView.reloadData()
                self.showError(networkError: error)
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.eraseData()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
        viewModel.fetchImageList()
    }
    
    private func configSearchBar() {
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Picsum"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Tìm kiếm theo tên tác giả/id..."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configTableView() {
        tableView.register(PicsumTableViewCell.nib, forCellReuseIdentifier: PicsumTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = loadingFooter
        loadingFooter.isHidden = true
        setupRefreshControl()
    }
    
    private func configActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    private func showValidationAlert() {
        guard !isShowingAlert else { return }
        isShowingAlert = true
        
        let alert = UIAlertController(title: "Error",
                                      message: "Vui lòng chỉ nhập chữ cái, số và khoảng trắng và các kí tự !@#$%^&*():.,<>/\\[]?. . Tối đa 15 ký tự.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.isShowingAlert = false
        })
        present(alert, animated: true)
    }
    
    private func showError(networkError: NetworkError) {
        let alert = UIAlertController(title: "Error",
                                      message: networkError.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            
        })
        present(alert, animated: true)
    }
    
    private func loadNextPageIfNeeded() {
        if !viewModel.reachPageLimit {
            loadingFooter.isHidden = false
            viewModel.loadMore()
        } else {
            loadingFooter.isHidden = true
        }
    }
    
 
}

extension PicsumHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PicsumTableViewCell.identifier) as? PicsumTableViewCell {
            cell.configCell(with: viewModel.item(at: indexPath))
            return cell
        }
        return UITableViewCell()
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        guard maximumOffset > 0 && currentOffset > 0 else { return }
        
        if maximumOffset - currentOffset <= -40.0 {
            self.loadNextPageIfNeeded()
        }
    }
}


extension PicsumHomeViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let validatedText = viewModel.validateSearchText(searchText)
        if validatedText != searchText {
            searchBar.text = validatedText
            showValidationAlert()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        let validatedText = viewModel.validateSearchText(searchText)
        viewModel.currentSearchText = validatedText
    }
}

