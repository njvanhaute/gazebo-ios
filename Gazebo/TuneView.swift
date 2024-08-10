//
//  ContentView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/8/24.
//

import SwiftUI

enum GazeboError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct TuneView: View {
    @State private var tune: GazeboTune?
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(tune?.title ?? "Title Placeholder")
                .bold()
                .font(.title3)
            Text(tune?.id.description ?? "ID Placeholder")
                .font(.caption)
            Text(tune?.keys.joined(separator: ", ") ?? "Keys Placeholder")
                .padding()
            Spacer()
        }
        .padding()
        .task {
            do {
                tune = try await getTune()
            } catch GazeboError.invalidURL {
                print("invalid URL")
            } catch GazeboError.invalidResponse {
                print("invalid response")
            } catch GazeboError.invalidData {
                print("invalid data")
            } catch {
                print("unexpected error")
            }
        }
    }
    
    func getTune() async throws -> GazeboTune {
        let endpoint = "http://localhost:4000/v1/tunes/3"
        
        guard let url = URL(string: endpoint) else {
            throw GazeboError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GazeboError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let serviceStore = try decoder.decode(GazeboTuneService.self, from: data)
            return serviceStore.tune
        } catch {
            throw GazeboError.invalidData
        }
    }
}

#Preview {
    TuneView()
}
