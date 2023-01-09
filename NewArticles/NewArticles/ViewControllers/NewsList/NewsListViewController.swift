//
//  NewsListViewController.swift
//  NewArticles
//
//  Created by Mayank Verma on 07/01/23.
//

import UIKit

class NewsListViewController: UIViewController {
    
    
    @IBOutlet weak var lblTitleNews: UILabel!
    @IBOutlet weak var btnSearchAndCancel: UIButton!
    @IBOutlet weak var txtFSearchBar: UITextField!
    @IBOutlet weak var constLeadingSearchView: NSLayoutConstraint!
    @IBOutlet weak var constWidthSearchView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var articles = [Article]()
    var viewModel = NewsListViewModel()
    var isSearchOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0) {
            if !self.isSearchOpen {
                self.txtFSearchBar.isHidden = false
                self.constLeadingSearchView.priority = UILayoutPriority.init(1000)
                self.btnSearchAndCancel.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
                self.btnSearchAndCancel.tintColor = .label
            } else {
                self.txtFSearchBar.isHidden = true
                self.constLeadingSearchView.priority = UILayoutPriority.init(998)
                self.btnSearchAndCancel.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
                self.btnSearchAndCancel.tintColor = .white
            }
            self.view.layoutIfNeeded()
        }
        if self.isSearchOpen {
            self.txtFSearchBar.text = ""
            Loader.shared.startAnimating()
            self.viewModel.fetchNewsList(searchItems: "")
        }
        self.isSearchOpen.toggle()
    }
    
    @IBAction func txtFDidEndEditing(_ sender: UITextField) {
        if self.txtFSearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            Loader.shared.startAnimating()
            self.viewModel.fetchNewsList(searchItems: self.txtFSearchBar.text ?? "")
        }
    }
    
}

extension NewsListViewController {
    
    func initialise() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.viewModel.delegate = self
        Loader.shared.startAnimating()
        self.viewModel.fetchNewsList(searchItems: "")
        self.txtFSearchBar.returnKeyType = .search
        self.txtFSearchBar.delegate = self
    }
}

extension NewsListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: NewsListTableViewCell.self)) as? NewsListTableViewCell {
            cell.initCell(article: self.articles[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = MainRoute.newsDetailsViewController.controller as? NewsDetailsViewController {
            vc.article = self.articles[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NewsListViewController: ProtoNewsListVM {
    func handleResponse(newsList: [Article]) {
        Loader.shared.stopAnimating()
        if let text = self.txtFSearchBar.text, text != ""{
            self.lblTitleNews.text = text + " News"
        } else {
            self.lblTitleNews.text = "iOS News"
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.txtFSearchBar.isHidden = true
            self.constLeadingSearchView.priority = UILayoutPriority.init(998)
            self.btnSearchAndCancel.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            self.btnSearchAndCancel.tintColor = .white
            self.view.layoutIfNeeded()
        }
        self.isSearchOpen = false
        self.articles = newsList
        self.tableView.reloadData()
    }
    
    func handleError(string: String) {
        Loader.shared.stopAnimating()
        UIAlertUtil.alertWith(title: "Error occured", message: "Please check and try again", viewController: self) { _ in }
    }
    
    
}
