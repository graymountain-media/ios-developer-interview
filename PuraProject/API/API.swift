//
//  API.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation

class API: NSObject {
    static private let session = URLSession.shared
    
    static let baseUrl = "https://www.dictionaryapi.com/api/v3/references/collegiate/json/"
    static let thesaurusUrl = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/"
    
    static func fetchWord(query: String, isThesaurus: Bool, _ completion: @escaping (Result<WordResponse, APIError>) -> Void) {
        guard !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        
        guard query.count > 2 else {
            completion(.failure(.tooShort(query)))
            return
        }
        
        var requestURL: String
        if isThesaurus {
            requestURL = URLBuilder(baseURL: API.thesaurusUrl, word: query.lowercased()).requestURL
        } else {
            requestURL = URLBuilder(baseURL: API.baseUrl, word: query.lowercased()).requestURL
        }
        
        guard let url = URL(string: requestURL) else {
            completion(.failure(.badURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        print("Fetching from: ", request.url?.absoluteString ?? "")
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode([WordResponse].self, from: data)
                if let firstResponse = response.first {
                    completion(.success(firstResponse))
                    return
                }
            } catch {
                print("WORD RESPONSE ERROR: ", error.localizedDescription)
            }
            
            completion(.failure(.noData))
        }.resume()
        
    }
    
}
