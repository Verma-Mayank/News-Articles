//
//  NewsListViewModel.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import Foundation

protocol ProtoNewsListVM: AnyObject {
    
    func handleResponse(newsList: [Article])
    func handleError(string: String)
}

struct NewsListViewModel {
    
    weak var delegate: ProtoNewsListVM?
    
    func fetchNewsList(searchItems: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let request = NewsRequest.init(title: searchItems == "" ? "ios" : searchItems, fromDate: dateString, sortBy: sortBy, apiKey: apiKey)
        
        let newsResource = NewsResource()
        newsResource.fetchNewsList(request: request) { response, error in
            if let response {
                self.delegate?.handleResponse(newsList: response.articles)
            } else {
                self.delegate?.handleError(string: error ?? "Error while fetching daily articles.")
            }
        }
    }
    
}
