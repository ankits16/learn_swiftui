//
//  DummyContainer.swift
//  Components
//
//  Created by Ankit Sachan on 17/10/23.
//

import SwiftUI

struct VariableWidthTextStack: View {
    let numbers = Array(1...100)
    
    @State private var textSizes: [Int: CGSize] = [:]

    var body: some View {
        VStack{
            HStack(alignment: .lastTextBaseline){
                Text("hello world")
                Text("Sleep tight")
                    .font(.title2)
            }
            .border(.green)
            .font(.largeTitle)
            Divider()
            Text("Another View")
        }
        .border(.red)
        
    }
}

struct BackgroundGeometryReader: View {
    let callback: (CGSize) -> Void

    var body: some View {
        GeometryReader { geometry in
            Color.clear.onAppear {
                callback(geometry.size)
            }
        }
    }
}




struct VariableWidthTextStack_Previews: PreviewProvider {
    static var previews: some View {
        VariableWidthTextStack()
    }
}

