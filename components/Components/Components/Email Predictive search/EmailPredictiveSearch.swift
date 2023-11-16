//
//  EmailPredictiveSearch.swift
//  Components
//
//  Created by Ankit Sachan on 12/11/23.
//

import SwiftUI

/**
 So this is bascially the mix of
 1) Predictve Search
 2) Flow Collection Layout
 
 */
struct EmailPredictiveSearch: View {
    @StateObject var viewModel : SearchViewModel
    @State private var layout: [UUID: FlowLayoutAlignmentGuide] = [:]
    var completion: (CGFloat) -> Void
    var spacing : CGFloat  = 10
    @State private var bubbleSizes: [UUID: CGSize] = [:]
    @State private var textFieldSize: CGSize = CGSize(width: 100, height: 40) // Default size, adjust as needed
    
    @State private var endForlastElement : CGFloat = CGFloat.zero
    @State private var topForlastElement : CGFloat = CGFloat.zero
    @State private var maxHeightForCurrentRow : CGFloat = CGFloat.zero
    
    
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        GeometryReader(content: { g in
            ZStack(alignment: .topLeading) {
                ForEach(viewModel.selectedRecords) { item in
                    let alignment = layout[item.id] ?? FlowLayoutAlignmentGuide(leading: 0, top: 0)
                    
                    // bubbles
                    BubbleView(item: item, removeAction: {
                        // Removal action
                        withAnimation {
                            viewModel.removeRecord(item)
//                            bubbleModel.removeItem(withID: item.id)
                            let (l, computedHeight) = getLayout(g)
                            layout = l
                            DispatchQueue.main.async {
                                completion(computedHeight)
                            }
                        }
                    })
                    .background(
                        GeometryReader { geometry in
                            Color.clear.onAppear {
                                debugPrint("<<<<<< \(item.text) bubble size calculated \(geometry.size)")
                                self.bubbleSizes[item.id] = geometry.size
                                let (l, computedHeight) = getLayout(g)
                                layout = l
                                DispatchQueue.main.async {
                                    completion(computedHeight)
                                }
                            }
                        }
                    )
                    .alignmentGuide(.leading, computeValue: { _ in
                        -alignment.leading
                    })
                    .alignmentGuide(.top) { _ in
                        -alignment.top
                    }
                }
                
                // Add a TextField at the end
                TextField("Type email address", text: $viewModel.query)
                    .onSubmit {
                        // Validate and add email to the model
                        if isValidEmail(viewModel.query) {
                            //we'll see what needs to be done
//                                viewModel.
//                                bubbleModel.addItem(BubbleItem(text: textInput))
//    //                            bubbleModel.addItem(textInput)
//                                textInput = "" // Clear the TextField
//                                let (l, computedHeight) = getLayout(g)
//                                layout = l
//                                DispatchQueue.main.async {
//                                    completion(computedHeight)
//                                }
                        }
                    }
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            // Update the size state of the TextField
                            self.textFieldSize = geometry.size
                            let (l, computedHeight) = getLayout(geometry)
                            layout = l
                            DispatchQueue.main.async {
                                completion(computedHeight)
                            }
                        }
                    }
                )
                .overlay(
                    // Search State Displayer
                    SearchStateDisplayer(viewModel: viewModel)
                        .offset(y: -(60)) // Adjust this value to position the overlay as desired
                        .padding(.horizontal, 20) // Optional for horizontal padding
                    ,
                    alignment: .bottomLeading // Aligns the overlay to the top of the TextField
                )
                // Use the same alignment guides as the bubbles
                .alignmentGuide(.leading) { _ in
                    let alignment = getTextFieldAlignment(g)
                    return -alignment.leading
                }
                .alignmentGuide(.top) { _ in
                    let alignment = getTextFieldAlignment(g)
                    return -alignment.top
                }
            }
            .frame(width: g.size.width - 10)
            .background(Color.white)
            .border(.blue)
            .padding(.all, 5)
        })
        .padding(.all, 5)
        .border(.pink)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        return true
    }
    
    
    private func getLayout(_ g: GeometryProxy) -> ([UUID : FlowLayoutAlignmentGuide], CGFloat){
        
        var retVal = [UUID : FlowLayoutAlignmentGuide]()
        endForlastElement = -spacing
        topForlastElement = CGFloat.zero
        maxHeightForCurrentRow = CGFloat.zero
        let containerWidth : CGFloat = g.size.width - 5 //- 20
        for(index, rect) in viewModel.selectedRecords.enumerated(){
            
            let itemWidth = bubbleSizes[rect.id]?.width ?? 0
            let itemHeight = bubbleSizes[rect.id]?.height ?? 0
            
            var startForCurrentElement = endForlastElement + spacing
            if (startForCurrentElement + itemWidth)>(containerWidth){
                let topForCurrentElement = topForlastElement + maxHeightForCurrentRow + spacing
                startForCurrentElement = 0
                retVal[rect.id] = FlowLayoutAlignmentGuide(
                    leading: startForCurrentElement,
                    top: topForCurrentElement
                )
                topForlastElement = topForCurrentElement
                endForlastElement = itemWidth
                maxHeightForCurrentRow = CGFloat.zero
            }else{
                retVal[rect.id] = FlowLayoutAlignmentGuide(
                    leading: startForCurrentElement,
                    top: topForlastElement
                )
                endForlastElement = startForCurrentElement + itemWidth
            }
            maxHeightForCurrentRow = max(maxHeightForCurrentRow, itemHeight)
            
            
            debugPrint("item \(index) text = \(rect.text) whose width is \(itemHeight) height = \(itemHeight) start at \(startForCurrentElement) endat \(endForlastElement) top =\(retVal[rect.id]!.top) -- container width = \(containerWidth)"
                       
            )
        }
        let totalHeight = topForlastElement + maxHeightForCurrentRow
        return (retVal, totalHeight)
        
    }
    
    private func getTextFieldAlignment(_ g: GeometryProxy) -> FlowLayoutAlignmentGuide {
        let containerWidth : CGFloat = g.size.width - 5
        // Start from the beginning of the container by default
            var alignmentGuide = FlowLayoutAlignmentGuide(leading: 0, top: 0)

            // Assume we have a padding or inset on the container
            let horizontalInset: CGFloat = 10

            // Calculate the remaining width on the last line
            let remainingWidth = containerWidth - (endForlastElement + spacing + horizontalInset)

            // If there's enough space for the TextField on the current line
            if remainingWidth >= textFieldSize.width {
                // Position the TextField right after the last bubble on the same line
                alignmentGuide.leading = endForlastElement + spacing
                alignmentGuide.top = topForlastElement
            } else {
                // Not enough space, so move the TextField to the next line
                alignmentGuide.leading = 0
                alignmentGuide.top = topForlastElement + maxHeightForCurrentRow + spacing
            }

            return alignmentGuide
    }
}

struct EmailPredictiveSearch_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
            // Preview for testing
        EmailPredictiveSearch(viewModel: MockSearchViewModelWithSelectedRecords(
            [Record]())) { _ in
                
            }
    }
}
