//
//  NetworkLoader.swift
//  Credit Card Validator
//
//  Created by Karol Majka on 21/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

// MARK: DataDownloading protocol
protocol DataDownloading {
    func download(from url: URL, block: @escaping (Data) -> Void, error errorBlock: @escaping (Error) -> Void)
}

extension DataDownloading {
    func download(from url: URL, block: @escaping (Data) -> Void, error errorBlock: @escaping (Error) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) -> Void in
            if let unwrappedError = error {
                errorBlock(unwrappedError)
            } else if let unwrappedData = data {
                block(unwrappedData)
            }
        }
        task.resume()
    }

}

// MARK: - NetworkLoader
class NetworkLoader {

    // MARK: Shared Instance
    private init() { }
    
    static let shared: NetworkLoader = {
        let instance = NetworkLoader()
        return instance
    }()
}

// MARK: Static properties
extension NetworkLoader {
    static let scheme = "https"
    static let host = "api.bincodes.com"
    static let path = "/cc"
    static let format = "json"
    static let queryItemformat = URLQueryItem(name: "format", value: format)
    static let apiKey = "5232a9bca11e25c0f8eb4313ff2644be"
    static let queryItemApiKey = URLQueryItem(name: "api_key", value: apiKey)
    static let queryItemNameForCreditCard = "cc"
}

// MARK: Helpers
fileprivate extension NetworkLoader {
    func createURL(creditCard: String) -> URL {
        var components = URLComponents()

        components.scheme = NetworkLoader.scheme
        components.host = NetworkLoader.host
        components.path = NetworkLoader.path
        
        components.queryItems = []
        components.queryItems!.append(NetworkLoader.queryItemformat)
        components.queryItems!.append(NetworkLoader.queryItemApiKey)
        components.queryItems!.append(URLQueryItem(name: NetworkLoader.queryItemNameForCreditCard, value: creditCard))

        return components.url!
    }
    
    static func toDictionary(jsonData: Data) -> [String:Any]? {
        do {
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any]
            return dict
        } catch {
            return nil
        }
    }
}

// MARK: DataDownloading
extension NetworkLoader: DataDownloading {
    func download(creditCard: String, block: @escaping (CreditCard) -> Void, error errorBlock: @escaping (Error) -> Void) {
        let url = self.createURL(creditCard: creditCard)
        self.download(from: url, block: { data in
            if let dict = NetworkLoader.toDictionary(jsonData: data) {
                if let creditCardModel = CreditCard.init(json: dict) {
                    block(creditCardModel)
                } else if let bincodesError = BincodesError.init(json: dict) {
                    let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey: bincodesError.message]
                    let err = NSError(domain: "", code: Int(bincodesError.error) ?? -1, userInfo: userInfo)
                    errorBlock(err)
                }
            }
        }, error: { error in
            errorBlock(error)
        })
    }
}
