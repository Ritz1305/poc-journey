//
//  NetworkHandler.swift
//  POCApp
//
//  Created by Ritesh on 05/11/20.
//  Copyright © 2020 Ritesh. All rights reserved.
//

import Foundation
import UIKit

class NetworkHandler {
    
    func fetchHomeDetails(_ callback: ((Home?, Error?) -> Void)?) {
        guard let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts") else {
            callback?(nil, NetworkError.invalidRequest)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                callback?(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                 httpResponse.statusCode == 200,
                 let data = data,
                 let response = try? JSONDecoder().decode(Home.self, from: (String(data: data, encoding: .isoLatin1)?.data(using: .utf8))!) else {
                callback?(nil, NetworkError.invalidResponse)
                return
            }
            callback?(response, nil)
        }
        task.resume()
    }
    
    func fetchWikiImage(url: URL, _ callback: ((UIImage?, Error?) -> Void)?) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                callback?(nil, NetworkError.invalidResponse)
                return
            }
            let image = UIImage(data: data)
            callback?(image, nil)
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
}
