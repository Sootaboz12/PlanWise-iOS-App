//
//  PixabayResponse.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//


//
//  PixabayService.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//

import Foundation

// MARK: - Pixabay Response Models
struct PixabayResponse: Codable {
    let total: Int
    let totalHits: Int
    let hits: [PixabayImage]
}

struct PixabayImage: Codable, Identifiable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}

// MARK: - Pixabay Service
class PixabayService {
    private let apiKey = "53382346-6a8a9f522c009580ecb04f24e"
    private let baseURL = "https://pixabay.com/api/"
    
    func searchImages(query: String, perPage: Int = 6) async throws -> [PixabayImage] {
        // URL encode the query
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw PixabayError.invalidQuery
        }
        
        // Construct the URL
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(encodedQuery)&image_type=photo&per_page=\(perPage)&safesearch=true"
        
        guard let url = URL(string: urlString) else {
            throw PixabayError.invalidURL
        }
        
        // Make the API request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PixabayError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw PixabayError.apiError(statusCode: httpResponse.statusCode)
        }
        
        // Decode the response
        let decoder = JSONDecoder()
        let pixabayResponse = try decoder.decode(PixabayResponse.self, from: data)
        
        // Check if we got results
        if pixabayResponse.hits.isEmpty {
            throw PixabayError.noResults
        }
        
        return pixabayResponse.hits
    }
}

// MARK: - Pixabay Errors
enum PixabayError: LocalizedError {
    case invalidQuery
    case invalidURL
    case invalidResponse
    case apiError(statusCode: Int)
    case noResults
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidQuery:
            return "Invalid search query"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let statusCode):
            return "API error with status code: \(statusCode)"
        case .noResults:
            return "No results found"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}