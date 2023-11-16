//
//  BubbleChildView.swift
//  Components
//
//  Created by Ankit Sachan on 12/11/23.
//

import SwiftUI

struct BubbleChildView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}

struct BubbleChildView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleChildView(text: "Sample text")
    }
}
