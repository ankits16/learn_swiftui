//
//  CommaSeparatedBubblesView.swift
//  Components
//
//  Created by Ankit Sachan on 12/11/23.
//

import SwiftUI

struct CommaSeparatedBubblesView: View {
    @State private var inputText: String = ""
    private var items: [String] {
        inputText.split(separator: ",").map { String($0) }
    }
    
    var body: some View {
        VStack {
            TextField("Enter comma-separated values", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ScrollView {
                HStack {
                    ForEach(items, id: \.self) { item in
                        BubbleChildView(text: item)
                    }
                }
            }
        }
    }
}

struct CommaSeparatedBubblesView_Previews: PreviewProvider {
    static var previews: some View {
        CommaSeparatedBubblesView()
    }
}
