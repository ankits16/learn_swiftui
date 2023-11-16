//
//  FlowCollectionWithBubbleItem.swift
//  Components
//
//  Created by Ankit Sachan on 19/10/23.
//

import SwiftUI
import Combine


class BubbleItemsModel: ObservableObject {
    @Published var items: [BubbleItem]
    
    init(items: [BubbleItem]) {
        self.items = items
    }
    
    func addItem(_ bubbleItem : BubbleItem) {
        self.items.append(bubbleItem)
    }
    
    func removeItem(withID id: UUID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }
    }
}

struct FlowCollectionWithBubbleItem: View {
    var spacing : CGFloat  = 10
    //    @State private var areBubblesVisible: Bool = false
    //    @Binding var bubbleItems: [BubbleItem]
    @State private var textInput: String = ""
    @State private var textFieldSize: CGSize = CGSize(width: 100, height: 20) // Default size, adjust as needed
    @ObservedObject var bubbleModel: BubbleItemsModel
    @State private var layout: [UUID: FlowLayoutAlignmentGuide] = [:]
    @State private var bubbleSizes: [UUID: CGSize] = [:]
    @State private var endForlastElement : CGFloat = CGFloat.zero
    @State private var topForlastElement : CGFloat = CGFloat.zero
    @State private var maxHeightForCurrentRow : CGFloat = CGFloat.zero
    var completion: (CGFloat) -> Void
    
    init(model: BubbleItemsModel, completion: @escaping (CGFloat) -> Void) {
        self.bubbleModel = model
        self.completion = completion
    }
    var body: some View {
        GeometryReader(content: { g in
            ZStack(alignment: .topLeading) {
                ForEach(bubbleModel.items) { item in
                    let alignment = layout[item.id] ?? FlowLayoutAlignmentGuide(leading: 0, top: 0)
                    
                    // bubbles
                    BubbleView(item: item, removeAction: {
                        // Removal action
                        withAnimation {
                            bubbleModel.removeItem(withID: item.id)
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
                TextField("Type email address", text: $textInput)
                    .onSubmit {
                        // Validate and add email to the model
                        if isValidEmail(textInput) {
                            bubbleModel.addItem(BubbleItem(text: textInput))
//                            bubbleModel.addItem(textInput)
                            textInput = "" // Clear the TextField
                            let (l, computedHeight) = getLayout(g)
                            layout = l
                            DispatchQueue.main.async {
                                completion(computedHeight)
                            }
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
        for(index, rect) in bubbleModel.items.enumerated(){
            
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


struct FlowCollectionWithBubbleItem_Previews: PreviewProvider {
    static var model = BubbleItemsModel(items:  [
        BubbleItem(text: "Apple"),
//        BubbleItem(text: "Banana"),
//        BubbleItem(text: "Hello ankit \n sachan \n multiline"),
//
//        BubbleItem(text: "Ankit"),
//        BubbleItem(text: "Honeydew \n with hellow world \n 3 lines and a ooooo long text"),
//        BubbleItem(text: "Ankit"),
//        BubbleItem(text: "Just a normal long text"),
//        BubbleItem(text: "1 \n 2 \n 3 \n 4 \n 5"),
//        BubbleItem(text: "Grape"),
//        BubbleItem(text: "Grape"),
    ]
    )
    static let sampleStrings = [
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Elderberry",
        "Fig",
        "Grape",
        "Honeydew",
        "Honeydew \n with hellow world \n 3 lines and a ooooo long text",
        "Just a normal long text",
        " 1 \n 2 \n 3 \n 4 \n 5"
    ]
    
    static var previews: some View {
        //        FlowCollectionWithBubbleItem(model: model) { _ in }
        VStack {
            FlowCollectionWithBubbleItem(model: model) { h in
                debugPrint("***** computer height is \(h)")
            }
            HStack {
                Button("Add") {
                    let randomText = sampleStrings.randomElement() ?? "Default"
                    debugPrint("add \(randomText)")
                    model.items.append(BubbleItem(text: randomText))
                }
                .padding()
                .border(.red)
                Spacer().frame(width: 10)
                Button("Clear") {
                    model.items = []
                }
                .padding()
                .border(.red)
            }
            Spacer()
        }
    }
    
    
}
