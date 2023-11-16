//
//  LandmarkDetail.swift
//  Landmarks
//
//  Created by Ankit Sachan on 04/10/23.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData : ModelData
    var landmark : Landmark
    var index : Int{
        modelData.landmarks.firstIndex(where: {$0.id == landmark.id})!
    }
    @State var message : String = ""
    var body: some View {
        ScrollView {
            MapView()
                .frame(height: 300)
            CircleImage(landmark: landmark)
                .offset(y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.landmarks[index].isFavorite)
                }
                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.headline)
                .foregroundColor(.gray)
                Divider()
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
                Divider()
                Text("Comments:")
                    .font(.title2)
                Text("Message")
                TextEditor(text: $message)
//                TextField("Leave a message to the engineer", text: $message)
//                    .textFieldStyle(.roundedBorder)
//                    .lineLimit(nil)
//                    .textContentType(.none) // This ensures the return key works for new lines
//                    .submitLabel(.done)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
            }
            .padding()
            Spacer()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        LandmarkDetail(landmark: modelData.landmarks[1])
            .environmentObject(modelData)
    }
}
