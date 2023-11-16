//
//  LandmarkList.swift
//  Landmarks
//
//  Created by Ankit Sachan on 04/10/23.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = true
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    var body: some View {
        NavigationSplitView {
            List{
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favourites only")
                }
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        } detail: {
            Text("Select a Landmark")
        }

        
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
//        LandmarkList().previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
    }
}
