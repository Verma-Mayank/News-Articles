//
//  NetworkHelpersConstants.swift
//  NewArticles
//
//  Created by Mayank Verma on 08/01/23.
//

import Foundation

enum HUHttpMethods: String {
   case get = "GET"
//   case post = "POST"
//   case put = "PUT"
//   case delete = "DELETE"
}

enum HUHTTPCode: Int {
    case okCode = 200
    case badRequest = 400
    case unAuthorized = 401
    case notFound = 404
    case internalServerError = 500
}

enum HUErrorMessage: String {
    case emptyResponse = "Empty response received"
    case resultNotFound = "Result not found"
    case decodingError = "Decoding error"
}
