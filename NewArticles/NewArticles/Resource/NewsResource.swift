//
//  NewsResource.swift
//  NewArticles
//
//  Created by Mayank Verma on 09/01/23.
//

import Foundation

struct NewsResource {
    
    func fetchNewsList(request: NewsRequest, completion: @escaping(_ repsonse: NewsResponse?, _ error: String?) -> Void) {
        
        if let queryURL = request.converToQueryUrl(url: baseURL) {
            HTTPUtility.shared.request(parameters: request, responseType: NewsResponse.self, method: .get, url: queryURL) { response in
                switch response {
                case .success(let success):
                    completion(success, nil)
                case .failure(let failure):
                    completion(nil, failure.reason)
                }
            }
        }
    }
}
