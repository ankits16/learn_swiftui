//
//  VerticalFlowView.swift
//  Components
//
//  Created by Ankit Sachan on 19/10/23.
//

import SwiftUI

struct VerticalFlowView: View {
    @Binding var bubbleItems: [BubbleItem]
    var body: some View {
        
        VStack {
            ForEach(bubbleItems) { item in
                BubbleView(item: item)
            }
            
        }
    }
}

struct VerticalFlowView_Previews: PreviewProvider {
    @State static var items = [
            BubbleItem(text: "Sample 1"),
            BubbleItem(text: "Sample 2"),
            BubbleItem(text: "Sample 3")
        ]
    static var previews: some View {
        VerticalFlowView(bubbleItems: $items)
    }
}
