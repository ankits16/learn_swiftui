//
//  PlaceholderTextEditor.swift
//  Components
//
//  Created by Ankit Sachan on 08/11/23.
//

import SwiftUI

struct PlaceholderTextEditor: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(4)
            // Adding a background color to the TextEditor can help see the placeholder
                .background(Color.red) // Or use a color that contrasts well with the placeholder
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray) // Make sure this color is visible against the background
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            
        }
    }
}

struct PlaceholderTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        // You can use a constant binding for previews
        PlaceholderTextEditor(text: .constant(""), placeholder: "Type your message here...")
            .frame(height: 200)
            .padding()
            .border(Color.gray, width: 1)
            .cornerRadius(5)
    }
}
