//
//  ContentView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/8/24.
//

import SwiftUI

struct TuneView: View {
    let tune: GazeboTune

    init(for tune: GazeboTune) {
        self.tune = tune
    }

    var body: some View {
        HStack {
            Text(tune.title)
            VStack {
                Text("ID: \(tune.id.description)")
                Text("Keys: \(tune.keys.joined(separator: ", "))")
            }
            .font(.footnote)
        }
    }
}

#Preview {
    let tune = GazeboTune(
        id: 1,
        createdAt: "now",
        version: 1,
        title: "Homer the Roamer",
        keys: ["D major", "B minor"],
        timeSignatureUpper: 4,
        timeSignatureLower: 4,
        bandId: 2,
        status: "seedling"
    )

    return TuneView(for: tune)
}
