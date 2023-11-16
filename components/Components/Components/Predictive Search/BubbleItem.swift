//
//  BubbleItem.swift
//  Components
//
//  Created by Ankit Sachan on 19/10/23.
//

import SwiftUI

protocol BubbleItemProtocol : Identifiable, Equatable{
    var id: UUID {get}
    var text: String {get}
}

extension BubbleItemProtocol{
    var id: UUID { UUID() }
}

struct BubbleItem: BubbleItemProtocol {
//    var id: UUID = UUID()
    var text: String
}

//extension BubbleItem{
//    var width: CGFloat{
//        return 40
//    }
//    var height : CGFloat{
//        return 40
//    }
//}


