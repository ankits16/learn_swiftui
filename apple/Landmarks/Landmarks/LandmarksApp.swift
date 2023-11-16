//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Ankit Sachan on 04/10/23.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
