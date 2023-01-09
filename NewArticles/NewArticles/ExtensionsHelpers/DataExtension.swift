//
//  DataExtension.swift
//  NewArticles
//
//  Created by Mayank Verma on 07/01/23.
//

import Foundation

extension Encodable {
    
    func encodeToData() -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return data
        } catch {
            return nil
        }
    }
    
    func convertToQueryStringUrl(urlString: String) -> URL? {
        
        if var components = URLComponents(string: urlString) {
            if let requestDictionary = convertToDictionary() {
                var queryItems: [URLQueryItem] = []
                requestDictionary.forEach({ (key, value) in
                    let strValue = "\(value)"
                    queryItems.append(URLQueryItem(name: key, value: strValue))
                    
                })
                components.queryItems = queryItems
                return components.url!
            }
        }
        
        debugPrint("convertToQueryStringUrl => Error => Conversion failed, please make sure to pass a valid urlString and try again")
        
        return nil
    }
    
    func converToQueryUrl(url: URL) -> URL? {
        
        if var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false) {
            if let requestDictionary = convertToDictionary() {
                var queryItems: [URLQueryItem] = []
                requestDictionary.forEach({ (key, value) in
                    let strValue = "\(value)"
                    queryItems.append(URLQueryItem(name: key, value: strValue))
                    
                })
                components.queryItems = queryItems
                return components.url!
            }
        }
        
        debugPrint("convertToQueryStringUrl => Error => Conversion failed, please make sure to pass a valid urlString and try again")
        
        return nil
    }
    
    func convertToDictionary() -> [String: Any]? {
        do {
            let encoder = try JSONEncoder().encode(self)
            let result = (try? JSONSerialization.jsonObject(with: encoder, options: .allowFragments)).flatMap { $0 as? [String: Any] }
            
            return result
            
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
    func convertToUrlEncoded() -> Data? {
        if let dataDict = self.convertToDictionary() {
            let stringDict: [String: String] = dataDict.mapValues { value in
                return "\(value)"
            }
            let queryString = queryStringParamsToString(stringDict)
            let data = queryString.data(using: String.Encoding.utf8)
            return data
        }
        return nil
    }
    
    func queryStringParamsToString(_ dictionary: [String: Any]) -> String {
        return dictionary
            .map({(key, value) in "\(key)=\(value)"})
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    }
    
    func encodeRequestData() -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            let requestData = try jsonEncoder.encode(self)
            return requestData
        } catch {
            return nil
        }
    }

}
