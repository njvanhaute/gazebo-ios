//
//  GazeboAPIAgent.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

struct GazeboAPIAgent {
    let hostname = "http://localhost:4000/v1/"
    
    func getResource<T: Decodable>(from path: String) async throws -> T {
        let endpoint = hostname + path
        
        guard let url = URL(string: endpoint) else {
            throw GazeboAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GazeboAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let resource = try decoder.decode(T.self, from: data)
            return resource
        } catch {
            throw GazeboAPIError.invalidData
        }
    }
}
