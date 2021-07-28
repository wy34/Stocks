//
//  APICaller.swift
//  Stocks
//
//  Created by William Yeung on 7/28/21.
//

import Foundation

final class APICaller {
    // MARK: - Properties
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseUrl = ""
    }
    
    private enum Endpoint: String {
        case search
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
        case badResponse
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Helpers
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        return nil
    }
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(APIError.badResponse))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
