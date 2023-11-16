//
//  FlowLayoutChecker.swift
//  Components
//
//  Created by Ankit Sachan on 19/10/23.
//

import SwiftUI

struct FlowLayoutChecker: View {
    @ObservedObject var model = BubbleItemsModel(items: [])
    
    let sampleStrings = [
//        "Apple",
//        "Banana",
//        "Cherry",
//        "Date",
//        "Elderberry",
//        "Fig",
//        "Grape",
//        "Honeydew",
//        "Honeydew \n with hellow world \n 3 lines and a ooooo long text",
//        "Just a normal long text",
//        " 1 \n 2 \n 3 \n 4 \n 5",
        "ankit.sachan16@gmail.com",
        "manu.srivastava@gmail.com",
        "ramna.reddy@gmail.com",
        "raja@gmail.com",
        "kapil.singhal@gmail.com",
        "kapil.singhal+qa@gmail.com",
    ]
    @State private var flowLayoutHeight: CGFloat = 80
    var maxHeight : CGFloat = 400
    var body: some View {
        
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        FlowCollectionWithBubbleItem(model: model) { newHeight in
                            debugPrint("<<<< new height \(newHeight)")
                            flowLayoutHeight = newHeight + 20
                        }
                    }
                    .frame(height:max(flowLayoutHeight, maxHeight))
                    .padding()
                }
                .frame(maxHeight: min(maxHeight, flowLayoutHeight) )
                .border(.green)
                .onChange(of: model.items) { _ in
                        withAnimation {
                            // Scroll to the ID of the VStack, which is the ID of the last item
                            if let lastID = model.items.last?.id {
                                scrollProxy.scrollTo(lastID, anchor: .bottom)
                            }
                        }
                    }
            }
            
            
            HStack {
                Button(action: {
                    addItem()
                }, label: {
                    Text("Add Bubble Item")
                })
                .padding()
                .border(.blue)
                Spacer()
                    .frame(width: 20)
                Button(action: {
                    model.items = []
                }, label: {
                    Text("clear")
                }).padding()
                    .border(.blue)
            }
        }
        
    }
    
    func addItem() {
        let randomText = sampleStrings.randomElement() ?? "Default"
        debugPrint("add \(randomText)")
        let newItem = BubbleItem(text: randomText)
        model.addItem(newItem)
    }
}

struct FlowLayoutChecker_Previews: PreviewProvider {
    static var previews: some View {
        FlowLayoutChecker()
    }
}
