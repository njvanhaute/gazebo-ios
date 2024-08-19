//
//  RepertoireView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import SwiftUI

struct RepertoireView: View {
    let band: GazeboBand
    @ObservedObject private var tuneStore: TuneStore

    init(for band: GazeboBand) {
        self.band = band
        tuneStore = TuneStore(for: band)
    }

    var body: some View {
        content
            .task {
                do {
                    try await tuneStore.loadTunes()
                } catch {
                    print(error)
                }
            }
            .navigationTitle("\(band) Tunes")
            .toolbar {
                Button {
                    print("Add tune")
                } label: {
                    Image(systemName: "plus")
                }
            }
    }

    @ViewBuilder
    var content: some View {
        if tuneStore.tuneList == nil {
            ProgressView()
        } else {
            tuneList
        }
    }

    var tuneList: some View {
        List(tuneStore.tuneList!.tunes) { tune in
            NavigationLink(value: tune) {
                TuneView(for: tune)
                    .padding()
            }
        }
        .refreshable {
            Task {
                do {
                    try await tuneStore.loadTunes()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    RepertoireView(for: TestBand.SAQ)
}
