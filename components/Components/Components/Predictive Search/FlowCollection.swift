//
//  FlowCollection.swift
//  Components
//
//  Created by Ankit Sachan on 18/10/23.
//

import SwiftUI

struct ElementCoordinate{
    var x : CGFloat
    var y : CGFloat
    var rect : RectDim
}

struct RectDim : Identifiable, Hashable{
    let id : UUID = UUID()
    var width : CGFloat
    var height : CGFloat
}

struct FlowLayoutAlignmentGuide{
    var leading : CGFloat
    var top : CGFloat
}

protocol FlowDrawable : Identifiable, Hashable{
    var id : UUID {get}
    var width : CGFloat{get}
    var height : CGFloat{get}
}

struct FlowCollection: View {
    var spacing : CGFloat  = 10
    var rectDims : [RectDim] = [
        RectDim(width: 54.39619659328046, height: 60),
        RectDim(width: 179.86999004655664, height: 70),
        RectDim(width: 55.08442383370906, height: 50),
        RectDim(width: 140.83040884997754, height: 30),
        RectDim(width: 54.39619659328046, height: 40),
        RectDim(width: 54.39619659328046, height: 60),
        RectDim(width: 110.83040884997754, height: 30),
        RectDim(width: 510.83040884997754, height: 90),
        RectDim(width: 140.83040884997754, height: 30),
        RectDim(width: 54.39619659328046, height: 40),
        RectDim(width: 54.39619659328046, height: 60),
        RectDim(width: 110.83040884997754, height: 30),
    ]
    var body: some View {
        
        GeometryReader(content: { g in
            var map = getLayout(g)
            VStack {
                ZStack(alignment: .topLeading) {
                    ForEach(Array(map.keys), id: \.self) { key in
                        let value = map[key]!
                        
                        Rectangle()
                            .fill(.red)
                            .frame(
                                width: min(g.size.width, key.width) ,
                                height: key.height
                            )
                            .alignmentGuide(.leading) { _ in
                                -value.leading
                            }
                            .alignmentGuide(.top) { _ in
                                -value.top
                            }
                        
                        
                    }
                    
                    
                }

                .border(.blue)
                
            }
        })
        .padding(.all, 10)
        .frame(width: 420)
            .border(.green)
        
    }
    
    private func getLayout(_ g: GeometryProxy) -> [RectDim : FlowLayoutAlignmentGuide]{
        var retVal = [RectDim : FlowLayoutAlignmentGuide]()
        var endForlastElement : CGFloat = -spacing
        var topForlastElement = CGFloat.zero
        var maxHeightForCurrentRow = CGFloat.zero
        for(index, rect) in rectDims.enumerated(){
            var startForCurrentElement = endForlastElement + spacing
            if (startForCurrentElement + rect.width)>g.size.width{
                let topForCurrentElement = topForlastElement + maxHeightForCurrentRow + spacing
                startForCurrentElement = 0
                retVal[rect] = FlowLayoutAlignmentGuide(
                    leading: startForCurrentElement,
                    top: topForCurrentElement
                )
                topForlastElement = topForCurrentElement
                endForlastElement = rect.width
                maxHeightForCurrentRow = CGFloat.zero
            }else{
                retVal[rect] = FlowLayoutAlignmentGuide(
                    leading: startForCurrentElement,
                    top: topForlastElement
                )
                endForlastElement = startForCurrentElement + rect.width
            }
            maxHeightForCurrentRow = max(maxHeightForCurrentRow, rect.height)
            
            
            debugPrint("item \(index) whose width is \(rect.width) start at \(startForCurrentElement) endat \(endForlastElement) -- container width = \(g.size.width)")
        }
        
        return retVal
    }
}

struct FlowCollection_Previews: PreviewProvider {
    static var previews: some View {
        FlowCollection()
    }
}
