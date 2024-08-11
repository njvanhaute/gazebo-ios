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

    func postResource<T: Encodable, U: Decodable>(_ resource: T, to path: String) async throws -> U {
        let endpoint = hostname + path

        guard let url = URL(string: endpoint) else {
            throw GazeboAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        guard let encoded = try? JSONEncoder().encode(resource) else {
            print(resource)
            throw GazeboAPIError.invalidData
        }

        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)

        guard let response = response as? HTTPURLResponse else {
            throw GazeboAPIError.invalidResponse
        }

        if response.statusCode == 201 {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let responseObject = try decoder.decode(U.self, from: data)
                return responseObject
            } catch {
                throw GazeboAPIError.invalidData
            }
        }

        switch response.statusCode {
        case 500:
            throw GazeboAPIError.internalServerError
        default:
            throw GazeboAPIError.unhandledError
        }
    }
}
