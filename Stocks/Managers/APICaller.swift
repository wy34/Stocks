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
        static let apiKey = "c4265uaad3iegm5gf7m0"
        static let sandboxApiKey = "sandbox_c4265uaad3iegm5gf7mg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let secondsInADay: Double = 3600 * 24
    }
    
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
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
        var urlString = Constants.baseUrl + endpoint.rawValue + "?"
        
        var queryItems = [URLQueryItem]()
        
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        let queryString = queryItems.map({ "\($0.name)=\($0.value ?? "")" }).joined(separator: "&")
        urlString += queryString
        
        return URL(string: urlString)
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
    
    func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = url(for: .search, queryParams: ["q": safeQuery])
        request(url: url, expecting: SearchResponse.self, completion: completion)
    }
    
    func news(for type: NewsViewController.`Type`, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
            case .topStories:
                let url = url(for: .topStories, queryParams: ["category": "general"])
                request(url: url, expecting: [NewsStory].self, completion: completion)
            case .company(symbol: let symbol):
                let sevenDaysAgoDate = Date().addingTimeInterval(-(Constants.secondsInADay * 7))
                let todaysDate = Date()
                let url = url(for: .companyNews, queryParams: ["symbol": symbol, "from": sevenDaysAgoDate.toString(withFormat: "YYYY-MM-DD"), "to": todaysDate.toString(withFormat: "YYYY-MM-DD")])
                request(url: url, expecting: [NewsStory].self, completion: completion)
        }
    }
}
