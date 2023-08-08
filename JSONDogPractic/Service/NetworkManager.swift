//
//  NetworkManager.swift
//  JSONDogPractic
//
//  Created by Alexey Manokhin on 08.08.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(from url: URL, completion: @escaping(Result <Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let dogData = try? Data(contentsOf: url) else {
                completion(.failure(.decodingError))
                return
            }

      let decoder = JSONDecoder()
            guard let dog = try? decoder.decode(Dog.self, from: dogData) else {
                completion(.failure(.decodingError))
                return
            }
            guard let url = URL(string: dog.message) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            completion(.success(imageData))
        }
    }
}