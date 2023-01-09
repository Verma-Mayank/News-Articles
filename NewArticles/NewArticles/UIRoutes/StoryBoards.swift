//
//  StoryBoards.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import Foundation
import UIKit

enum Storyboards: String {
    
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard.init(name: self.rawValue, bundle: nil)
    }
}
