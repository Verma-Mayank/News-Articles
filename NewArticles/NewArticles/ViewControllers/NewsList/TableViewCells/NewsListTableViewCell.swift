//
//  NewsListTableViewCell.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import UIKit
import SDWebImage

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVTitle: UIImageView!
    @IBOutlet weak var lblTitleHeading: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initCell(article: Article) {
        self.lblAuthor.text = article.author
        self.lblSource.text = article.source.name
        if let urlImage = article.urlToImage, let url = URL(string: urlImage) {
            self.imageVTitle.sd_setImage(with: url)
        }
        self.lblTitleHeading.text = article.title
    }

}
