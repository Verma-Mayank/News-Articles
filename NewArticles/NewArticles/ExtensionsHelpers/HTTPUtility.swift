//
//  HTTPUtility.swift
//  NewArticles
//
//  Created by Mayank Verma on 07/01/23.
//

import Foundation
import UIKit

class HTTPUtility: NSObject {
    
    static let shared = HTTPUtility()
        
    // MARK: - Private functions
    private override init() {
        super.init()
    }
    
    private func createJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func request<Resp: Decodable, Param: Encodable>(parameters: Param?,
                                                     responseType: Resp.Type,
                                                     method: HUHttpMethods,
                                                     url: URL,
                                                            completionHandler: @escaping (Result<Resp?, NetworkError>) -> Void) {
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method != .get {
            request.httpBody = parameters.encodeToData()
        }
        
        URLSession.shared.dataTask(with: request) { (data, httpUrlResponse, error) in
            
            DispatchQueue.main.async {
                guard let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode,
                      let data = data else {
                    let networkError = NetworkError(
                        withServerResponse: data,
                        forRequestUrl: request.url!,
                        withHttpBody: request.httpBody,
                        errorMessage: error?.localizedDescription ?? HUErrorMessage.emptyResponse.rawValue,
                        forStatusCode: HUHTTPCode.internalServerError.rawValue)
                    completionHandler(.failure(networkError))
                    return
                }
                if statusCode == HUHTTPCode.okCode.rawValue {
                    if let response = self.decodeJsonResponse(data: data, responseType: responseType) {
                        completionHandler(
                            .success(response)
                        )
                    } else {
                        completionHandler(
                            .failure(
                                NetworkError(
                                    withServerResponse: data,
                                    forRequestUrl: request.url!,
                                    withHttpBody: request.httpBody,
                                    errorMessage: HUErrorMessage.decodingError.rawValue,
                                    forStatusCode: statusCode)
                            )
                        )
                    }
                } else if statusCode == HUHTTPCode.badRequest.rawValue || statusCode == HUHTTPCode.notFound.rawValue {
                    if let response = self.decodeJsonResponse(data: data, responseType: APIErrorResponse.self) {
                        completionHandler(
                            .failure(
                                NetworkError(
                                    withServerResponse: data,
                                    forRequestUrl: request.url!,
                                    withHttpBody: request.httpBody,
                                    errorMessage: response.message,
                                    forStatusCode: statusCode
                                )
                            )
                        )
                    } else {
                        completionHandler(
                            .failure(
                                NetworkError(
                                    withServerResponse: data,
                                    forRequestUrl: request.url!,
                                    withHttpBody: request.httpBody,
                                    errorMessage: HUErrorMessage.decodingError.rawValue,
                                    forStatusCode: statusCode)
                            )
                        )
                    }
                } else if statusCode == HUHTTPCode.unAuthorized.rawValue {
                    DispatchQueue.main.async {
                        
                    }
                } else {
                    let networkError = NetworkError(
                        withServerResponse: data,
                        forRequestUrl: request.url!,
                        withHttpBody: request.httpBody,
                        errorMessage: error?.localizedDescription ?? HUErrorMessage.emptyResponse.rawValue,
                        forStatusCode: statusCode
                    )
                    completionHandler(.failure(networkError))
                }
            }
        }.resume()
        
    }
    
    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = createJsonDecoder()
        do {
            return try decoder.decode(responseType, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            debugPrint(context)
        } catch let DecodingError.keyNotFound(key, context) {
            debugPrint("Key '\(key)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            debugPrint("Value '\(value)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch {
            debugPrint("error: ", error)
        }
        return nil
    }
}

public struct NetworkError: Error {
    
    let reason: String?
    let httpStatusCode: Int?
    let request: URL?
    let requestBody: String?
    let serverResponse: String?
    
    init(withServerResponse response: Data? = nil, forRequestUrl url: URL, withHttpBody body: Data? = nil, errorMessage message: String, forStatusCode statusCode: Int) {
        self.serverResponse = response != nil ? String(data: response!, encoding: .utf8) : nil
        self.request = url
        self.requestBody = body != nil ? String(data: body!, encoding: .utf8) : nil
        self.httpStatusCode = statusCode
        self.reason = message
    }
}
