//
//  ZstactAttempt1.swift
//  Components
//
//  Created by Ankit Sachan on 19/10/23.
//

import SwiftUI

struct ZstactAttempt1: View {
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .topLeading) {
                Text("Hello")
            }
            .frame(width: g.size.width)
            .border(.green)
        }
        .padding(10)
        .border(.red)
    }
}

struct ZstactAttempt1_Previews: PreviewProvider {
    static var previews: some View {
        ZstactAttempt1()
    }
}
