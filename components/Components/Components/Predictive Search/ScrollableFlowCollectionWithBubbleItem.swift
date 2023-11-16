//
//  ScrollableFlowCollectionWithBubbleItem.swift
//  Components
//
//  Created by Ankit Sachan on 19/10/23.
//

import SwiftUI

struct ScrollableFlowCollectionWithBubbleItem: View {
    @State var items : [BubbleItem]
    var body: some View {
        ScrollView {
//            FlowCollectionWithBubbleItem(items: $items) { _ in
//                
//            }
        }
        .border(.blue)
        
    }
}

struct ScrollableFlowCollectionWithBubbleItem_Previews: PreviewProvider {
    @State static var items = [
        BubbleItem(text: "Hello"),
        BubbleItem(text: "World"),
        BubbleItem(text: "Hello ankit \n sachan \n multiline"),

        BubbleItem(text: "Ankit"),
        BubbleItem(text: "Ankit"),
        BubbleItem(text: "Ankit"),
        BubbleItem(text: "Ankit1"),

    ]
    static var previews: some View {
        ScrollableFlowCollectionWithBubbleItem(items: items)
    }
}
