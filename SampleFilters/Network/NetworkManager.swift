//
//  NetworkManager.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 20/06/23.
//

import Foundation

public enum NetworkManagerError: Error {
    case unknown
    case invalidURLComps
    case invalidURL
    case badResponse
}


public class NetworkManager {

    private let apiKey = "aZcCGll5r5Tyal7dxOLHCLDAHAOZA4iw"
    private var newsCategory: String = "mostviewed"
    private var newsSection: String = "all-sections"
    private var newsPeriod: String = "7"

    private func loadData<T: Decodable>(fromUrl url: URL?) async throws -> T {
        let result:T = try await networkRequest_Get_Async(forURL: url)
        return result
    }
    
    private func networkRequest_Get_Async<T: Decodable>(forURL url: URL?) async throws -> T {
        guard let url = url else {
            throw NetworkManagerError.invalidURL}
        let (data, response) = try await URLSession.shared.data(from: url)
        guard response is HTTPURLResponse else {
            throw NetworkManagerError.badResponse
        }
        let results = try JSONDecoder().decode(T.self, from: data)
        return results
    }
    
    private func generateURL(withParams params: (Sections,Periods)) throws-> URL? {
        var url = "http://api.nytimes.com/svc/mostpopular/v2/"
        url += "\(params.0.rawValue)/"
        url += "\(newsSection)/"
        url += "\(params.1.rawValue)"
        url += ".json"
        let queryItems = [URLQueryItem(name: "api-key", value: "\(apiKey)")]
        guard var urlComps = URLComponents(string: url) else {
            throw NetworkManagerError.invalidURLComps}
        urlComps.queryItems = queryItems
        return urlComps.url
    }

    func loadLandingPageData(withParams params: (Sections,Periods))async -> Swift.Result<NewsModel, NetworkManagerError> {
        do {
            let landingPageData: NewsModel = try await loadData(fromUrl: generateURL(withParams: params))
            return .success(landingPageData)
        } catch {
            return .failure(.unknown)
        }
    }
    
}




