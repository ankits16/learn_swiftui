//
//  ZStackViews.swift
//  Components
//
//  Created by Ankit Sachan on 18/10/23.
//

import SwiftUI

struct ZStackViews: View {
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .onTapGesture {
                                        print("Red Rectangle Tapped!")
                                    }
                Rectangle()
                    .frame(width: 75, height: 50)
                    .foregroundColor(.blue)
                    .onTapGesture {
                                        print("blue Rectangle Tapped!")
                                    }
            }
            
            ZStack{
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                Rectangle()
                    .frame(width: 50, height: 75)
                    .foregroundColor(.blue)
            }
            
            ZStack{
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                Rectangle()
                    .frame(width: 75, height: 50)
                    .foregroundColor(.blue)
            }
            
            ZStack{
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                Rectangle()
                    .frame(width: 50, height: 75)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ZStackViews_Previews: PreviewProvider {
    static var previews: some View {
        ZStackViews()
    }
}
