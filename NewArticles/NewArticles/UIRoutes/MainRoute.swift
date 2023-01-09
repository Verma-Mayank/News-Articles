//
//  MainRoute.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import Foundation
import UIKit

enum MainRoute: String {
    
    static let storyBoard = Storyboards.main.instance
    
    case newsListViewController = "NewsListViewController"
    case newsDetailsViewController = "NewsDetailsViewController"
    
    var controller: UIViewController {
        return MainRoute.storyBoard.instantiateViewController(withIdentifier: self.rawValue)
    }
}

