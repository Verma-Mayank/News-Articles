//
//  NewsRequest.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import Foundation

struct NewsRequest: Encodable {
    
    var title: String
    var fromDate: String
    var sortBy: String
    var apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case title = "qInTitle"
        case fromDate = "from"
        case sortBy, apiKey
    }
}
