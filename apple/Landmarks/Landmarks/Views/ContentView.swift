//
//  ContentView.swift
//  Landmarks
//
//  Created by Ankit Sachan on 04/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
            .environmentObject(ModelData())
//        VStack {
//            VStack(alignment: .leading) {
//
//                Text("Turtle Rock")
//                    .font(.title)
//                HStack {
//                    Text("Joshua Tree National Park")
//                    Spacer()
//                    Text("California")
//                }
//                .font(.headline)
//                .foregroundColor(.gray)
//                Divider()
//
//                Text("About Turtle Rock")
//                    .font(.title2)
//                Text("Descrptive text goes here.")
//
//            }
//            .padding()
//            Spacer()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
