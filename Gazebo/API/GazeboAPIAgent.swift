//
//  GazeboAPIAgent.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

extension URLRequest {
    mutating func addAuthToken() async throws {
        if GazeboAuthentication.shared.tokenTTL() < .fiveMinutes {
            do {
                try await GazeboAuthentication.shared.reauthenticateWithStoredCredentials()
            } catch {
                // failed to reauthenticate; log out since we can't make any API calls
                GazeboAuthentication.shared.logout()
                throw GazeboAPIError.internalServerError
            }
        }
        let email = GazeboAuthentication.shared.getEmail()!
        let token = GazeboAuthentication.shared.getToken(for: email)!
        addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

struct GazeboAPIAgent {
    let hostname: String

    static let shared = GazeboAPIAgent()

    private init() {
        hostname = "https://api.gazebosoftware.com/v1/"
    }

    func getResource<T: Decodable>(from path: String, authenticate: Bool) async throws -> T {
        let endpoint = hostname + path

        guard let url = URL(string: endpoint) else {
            throw GazeboAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if authenticate && GazeboAuthentication.shared.loggedIn {
            try await request.addAuthToken()
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw GazeboAPIError.invalidResponse
        }

        if response.statusCode != 200 {
            switch response.statusCode {
            case 403:
                throw GazeboAPIError.accountNotActivated
            case 401:
                throw GazeboAPIError.statusUnauthorized
            default:
                throw GazeboAPIError.unhandledError
            }
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

    func postResource<T: Encodable, U: Decodable>(
        _ resource: T,
        to path: String,
        authenticate: Bool) async throws -> U {
            let endpoint = hostname + path

            guard let url = URL(string: endpoint) else {
                throw GazeboAPIError.invalidURL
            }

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            if authenticate && GazeboAuthentication.shared.loggedIn {
                try await request.addAuthToken()
            }

            guard let encoded = try? JSONEncoder().encode(resource) else {
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
                    print(response)
                    throw GazeboAPIError.invalidData
                }
            }

            switch response.statusCode {
            case 500:
                throw GazeboAPIError.internalServerError
            case 401:
                throw GazeboAPIError.statusUnauthorized
            case 403:
                throw GazeboAPIError.accountNotActivated
            default:
                throw GazeboAPIError.unhandledError
            }
        }

    func putResource<T: Encodable, U: Decodable>(_ resource: T, to path: String) async throws -> U {
        let endpoint = hostname + path

        guard let url = URL(string: endpoint) else {
            throw GazeboAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"

        guard let encoded = try? JSONEncoder().encode(resource) else {
            throw GazeboAPIError.invalidData
        }

        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)

        guard let response = response as? HTTPURLResponse else {
            throw GazeboAPIError.invalidResponse
        }

        if response.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let responseObject = try decoder.decode(U.self, from: data)
                return responseObject
            } catch {
                print(response)
                throw GazeboAPIError.invalidData
            }
        }

        switch response.statusCode {
        case 500:
            throw GazeboAPIError.internalServerError
        case 401:
            throw GazeboAPIError.statusUnauthorized
        case 403:
            throw GazeboAPIError.accountNotActivated
        case 422:
            throw GazeboAPIError.unprocessableEntity
        default:
            throw GazeboAPIError.unhandledError
        }
    }

    func healthcheck() async -> Bool {
        if !GazeboAuthentication.shared.loggedIn { return true }
        do {
            let url = URL(string: hostname + "healthcheck")
            let (_, response) = try await URLSession.shared.data(from: url!)

            guard let response = response as? HTTPURLResponse else {
                throw GazeboAPIError.invalidResponse
            }

            return response.statusCode == 200
        } catch {
            return false
        }
    }
}
