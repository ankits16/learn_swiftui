//
//  WrappingRow.swift
//  Components
//
//  Created by Ankit Sachan on 18/10/23.
//

import SwiftUI


struct WrappingRow: View {
    @State private var displayedItems: [BubbleItem]
    var completion: (CGFloat) -> Void
    
    @State private var currentPosition: CGSize = .zero

    
    init(items: [BubbleItem], completion: @escaping (CGFloat) -> Void) {
        self._displayedItems = State(initialValue: items)
        self.completion = completion
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: 400)
        .border(.green)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.displayedItems) { item in
                self.bubble(for: item)
                    .padding([.horizontal], 5)
                    .padding([.top], 20)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item.id == self.displayedItems.last!.id {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height 
                        if item.id == self.displayedItems.last!.id {
                            height = 0
                        }
                        return result
                    })
            }
        }.background(viewHeightReader(completion))
    }
    
    private func bubble(for item: BubbleItem) -> some View {
        BubbleView(item: item) {
            if let index = displayedItems.firstIndex(where: { $0.id == item.id }) {
                displayedItems.remove(at: index)
            }
        }
    }
    
    private func viewHeightReader(_ binding: @escaping (CGFloat) -> Void) -> some View {
        return GeometryReader { geometry -> Color in
            let height = geometry.frame(in: .local).size.height
            
            DispatchQueue.main.async {
                binding(height)
            }
            
            return .clear
        }
    }
}


struct WrappingRow_Previews: PreviewProvider {
    static var previews: some View {
        WrappingRow(items: [
            BubbleItem(text: "apple"),
            BubbleItem(text: "banana"),
            BubbleItem(text: "cherry"),
            BubbleItem(text: "date"),
            BubbleItem(text: "elderberry"),
            BubbleItem(text: "fig"),
            BubbleItem(text: "Help me undertand why this text is soooooooooooooooooooooo long"),
            BubbleItem(text: "raspberry"),
            BubbleItem(text: "xigua"),
            BubbleItem(text: "yellow"),
            BubbleItem(text: "This is a very long text \n multine as well")
        ], completion: {_ in }
        )
    }
}
