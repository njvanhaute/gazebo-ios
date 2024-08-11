//
//  TuneListView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import SwiftUI

struct TuneListView: View {
    @ObservedObject var store: TuneStore
    
    var body: some View {
        tuneList
            .onAppear {
                Task {
                    try await store.loadTunes()
                }
            }
    }
    
    @ViewBuilder
    var tuneList: some View {
        if store.tuneList == nil {
            ProgressView()
        } else {
            ScrollView {
                VStack {
                    ForEach(store.tuneList!.tunes) { tune in
                        TuneView(for: tune)
                    }
                }
            }
        }
    }
}

#Preview {
    @StateObject var store = TuneStore(for: GazeboBand(id: 1, ownerId: 1, createdAt: "", version: 1, name: ""))
    return TuneListView(store: store)
}
