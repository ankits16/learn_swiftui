//
//  SampleTextfield.swift
//  Components
//
//  Created by Ankit Sachan on 15/11/23.
//

import SwiftUI

struct SampleTextfield: View {
    @State private var currentText: String = ""
    @State private var currentText2: String = ""
    @State private var textArray: [String] = []
    @State private var textFieldKey: UUID = UUID()
    
    var body: some View {
        VStack {
            Text("Current State: \(currentText.isEmpty ? "Empty" : "Not Empty")")
            TextField("Enter text", text: $currentText, onCommit: addText)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding()
                           .id(textFieldKey)  // Apply unique key
            TextField("Enter text 2", text: $currentText2)
                .onSubmit {
                    if !currentText2.isEmpty {
                        print("before Text cleared \(currentText2) \(currentText2.count)")
                        textArray.append(currentText2)
                        currentText2 = ""
                        print("Text cleared \(currentText) \(currentText.count) \(textFieldKey)") // Debugging: Check if this gets printed
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            List(textArray, id: \.self) { text in
                Text(text)
            }
            Button("Clear text") {
                addText()
            }
        }
    }
    
    private func addText() {
        if !currentText.isEmpty {
            print("before Text cleared \(currentText) \(currentText.count) \(textFieldKey)")
            textArray.append(currentText)
            currentText = ""
            textFieldKey = UUID()
            print("Text cleared \(currentText) \(currentText.count) \(textFieldKey)") // Debugging: Check if this gets printed
        }
    }
}

struct SampleTextfield_Previews: PreviewProvider {
    static var previews: some View {
        SampleTextfield()
    }
}
