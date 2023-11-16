//
//  PredictiveSearch.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import SwiftUI


/**
 predictive search has 3 components:
 1.Textfield
 2.Search State Displayer
 3.Selected Records
 */
struct PredictiveSearchView: View {
    @StateObject var viewModel : SearchViewModel //= SearchViewModel()
    
    var body: some View {
        VStack {
            // Search input
            TextField("Search", text: $viewModel.query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .overlay(
                    // Search State Displayer
                    SearchStateDisplayer(viewModel: viewModel)
                        .offset(y: -(60)) // Adjust this value to position the overlay as desired
                        .padding(.horizontal, 20) // Optional for horizontal padding
                    ,
                    alignment: .bottomLeading // Aligns the overlay to the top of the TextField
                )
            
            // Selected Records
            if !viewModel.selectedRecords.isEmpty {
                HStack {
                    Text("Selected Records:")
                    Button("Clear") {
                        viewModel.clearAllSelections()
                    }
                }
                VStack {
                    ForEach(viewModel.selectedRecords, id: \.id) { record in
                        HStack {
                            Text(record.text)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10) // Horizontal padding for text inside the bubble
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.removeRecord(record)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(8) // Padding around the HStack to create the bubble effect
                        .background(Color.gray.opacity(0.2)) // Light gray color
                        .cornerRadius(15) // Rounded corners to form a bubble shape
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct PredictiveSearch_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for testing
            PredictiveSearchView(viewModel: SearchViewModel())
                .previewDisplayName("Testable")
            
            // Preview for idle state
            PredictiveSearchView(viewModel: MockSearchViewModel(state: .idle))
                .previewDisplayName("Idle State")
            
            // Preview for fetching state
            PredictiveSearchView(viewModel: MockSearchViewModel(state: .fetching))
                .previewDisplayName("Fetching State")
            
            // Preview for fetched state with sample records
            PredictiveSearchView(viewModel: MockSearchViewModel(state: .fetched([
                Record(text: "Apple"),
                Record(text: "Banana"),
                //                Record(id: 3, name: "Apple3"),
            ])))
            .previewDisplayName("Fetched Records State: Sum of items")
            
            // Preview for fetched state with sample records
            PredictiveSearchView(viewModel: MockSearchViewModel(state: .fetched([
                Record(text: "Apple"),
                Record(text: "Banana"),
                Record(text: "Apple3"),
                Record(text: "Banana4"),
                Record(text: "Apple5"),
                Record(text: "Banana6 \n new line banana \n mmm \n                kkkkkk")
            ])))
            .previewDisplayName("Fetched Records State: Max height")
            
            // Preview for failed state
            PredictiveSearchView(viewModel: MockSearchViewModel(state: .failed("No records found")))
                .previewDisplayName("Failed State")
        }
    }
}
