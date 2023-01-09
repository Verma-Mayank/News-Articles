//
//  APIErrorResponse.swift
//  NewArticles
//
//  Created by Mayank Verma on 08/01/23.
//

import Foundation

struct APIErrorResponse: Decodable {
    let error: Bool
    let message: String
}

struct ErrorMessage: Decodable {
    let message: String
}
