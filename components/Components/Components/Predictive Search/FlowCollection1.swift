//
//  FlowCollection1.swift
//  Components
//
//  Created by Ankit Sachan on 18/10/23.
//

import SwiftUI

struct FlowCollection1: View {
    let numberOfRectangles = 5
    var spacing: CGFloat = 10
    // Generate random properties for the rectangles
    var rectangles: [(width: CGFloat, height: CGFloat, color: Color)] = (0..<10).map { _ in
        let width = CGFloat.random(in: 50...200)
        let height : CGFloat = 80 // CGFloat.random(in: 40...80)
        let blueValue = Double.random(in: 0...1)
        let greenValue = Double.random(in: 0...1)
        let redValue = Double.random(in: 0...1)
        let color = Color(red: redValue, green: greenValue, blue: blueValue)
        return (width: width, height: height, color: color)
    }
    var body: some View {
        GeometryReader(content: { geometry in
            generateContent(in: geometry)
        })
        .padding()
        .border(.red)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View{
        var map : [Int : ElementCoordinate] = [Int : ElementCoordinate]()
        var width : CGFloat = -spacing
        var height = CGFloat.zero
        var maxHeightOfElementInRow = CGFloat.zero
        print("executing generate content")
        return ZStack(alignment: .topLeading) {
            
            ForEach(0..<numberOfRectangles) { index in
                ZStack {
                    
                    Rectangle()
                        .fill(rectangles[index].color)
                        .frame(width: rectangles[index].width, height: rectangles[index].height)
                    Text("\(index)")
                }.alignmentGuide(.leading) { d in
                    // Calculate the total leading space required for current rectangle
                    if let val =  map[index]{
                        return -val.x
                    }else{
                        let widthRequiredByCurrentElement = width + spacing + d.width
                        debugPrint("width required at \(index)= \(width) + \(spacing) + \(d.width) ,** sum = \(widthRequiredByCurrentElement) and container width = \(g.size.width)")
                        if (widthRequiredByCurrentElement > g.size.width) {
                            debugPrint("***** move to next row")
                            width = -spacing
                            height = height + d.height + max(maxHeightOfElementInRow, spacing)
                            maxHeightOfElementInRow = 0
                        }else{
                            debugPrint("*** since element can be drawn on same row hence")
                            width = widthRequiredByCurrentElement
                        }
                        map[index] = ElementCoordinate(x: width, y: height, rect: RectDim(width: 0, height: 0))
                        return -width
                    }
                    
                    //                        let previousWidths = rectangles.prefix(index).map { $0.width }.reduce(0, +)
                    //                        return -(previousWidths + CGFloat(index) * spacing)
                }
                .alignmentGuide(.top) { d in
                    return  -map[index]!.y
                }
            }
        }
        .border(Color.blue)
    }
}

struct FlowCollection1_Previews: PreviewProvider {
    static var previews: some View {
        FlowCollection1()
    }
}
