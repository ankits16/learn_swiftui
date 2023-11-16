//
//  CircleImage.swift
//  Landmarks
//
//  Created by Ankit Sachan on 04/10/23.
//

import SwiftUI

struct CircleImage: View {
    var landmark : Landmark
    var body: some View {
        landmark.image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4.0)
            }
            .shadow(radius: 7.0)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(landmark: ModelData().landmarks[0])
    }
}
