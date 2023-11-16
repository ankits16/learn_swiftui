//
//  CustomFlowLayoutView.swift
//  Components
//
//  Created by Ankit Sachan on 12/11/23.
//

import SwiftUI

struct CustomFlowLayoutView<Content: View>: View{
    var items: [String] // Array of items to display
    var itemContent: (String) -> Content // Closure to create views for items
    @State private var widths: [CGFloat] = []
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let containerWidth = geometry.size.width
                var widthSoFar = CGFloat.zero
                
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                            itemContent(item)
                                .padding([.horizontal, .vertical], 4)
                                .alignmentGuide(.leading) { d in
                                    if (abs(widthSoFar - d.width) > containerWidth) {
                                        widthSoFar = 0 // Reset width counter
                                        return d.width
                                    }
                                    let width = widthSoFar
                                    if index == items.endIndex - 1 {
                                        widthSoFar = 0 // Last item, reset width counter
                                    } else {
                                        widthSoFar -= d.width
                                    }
                                    return -width
                                }
                        }
                    }
                }
            }
        }
    }
}

struct FlowLayoutContainer : View{
    var emails = ["test@example.com", "hello@world.com", "example@test.com", "user@domain.com", "sample@email.com"]

        var body: some View {
            CustomFlowLayoutView(items: emails) { item in
                Text(item)
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
}

struct CustomFlowLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FlowLayoutContainer()
    }
}
