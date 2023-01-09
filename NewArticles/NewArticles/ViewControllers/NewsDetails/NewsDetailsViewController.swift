//
//  NewsDetailsViewController.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var lblSourceName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imageView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }

    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewsDetailsViewController {
    func initialise() {
        guard let article = self.article else {
            return
        }
        if let url = URL.init(string: article.urlToImage ?? "") {
            self.imageView.sd_setImage(with: url)
        }
        self.lblTitle.text = article.title
        self.lblContent.text = article.content
        self.lblAuthorName.text = "Author: \(article.author ?? "Anonymous")"
        self.lblSourceName.text = "Source: \(article.source.name)"

    }
}
