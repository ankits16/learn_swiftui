//
//  SearchStateDisplayer.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import SwiftUI

/**
 This displays the search result of predicitve search
 it can be in 3 states
 1. Fetching Records
 2. Fetched records successfully and show list of suggestions
 3. Unable o fetch records or no records found
 */
struct SearchStateDisplayer: View {
    @ObservedObject var viewModel: SearchViewModel
    var body: some View {
        VStack{
            switch viewModel.searchState {
            case .fetching:
                HStack {
                    ProgressView()
                    Spacer().frame(width: 10) // Adds a 10-point space
                    Text("Fetching Records...")
                }
                .padding()  // Add padding around the content
                .background(Color.gray)  // Green background
                .cornerRadius(10)  // Rounded corners
                .foregroundColor(.white)  // White text color
                
            case .fetched:
                VStack {
                    FetchedRecordsView(viewModel: viewModel)
                } //(records: records)
            case .failed(let errorMessage):
                Text(errorMessage)
                    .padding()  // Add padding around the content
                    .background(Color.gray)  // Green background
                    .cornerRadius(10)  // Rounded corners
                    .foregroundColor(.white)  // White text color
            case .idle:
                EmptyView()
            }
        }
//        .onChange(of: viewModel.searchState) { newValue in
//            debugPrint("<<<<< new state \(newValue)")
//        }
    }
}

struct SearchStateDisplayer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchStateDisplayer(viewModel: MockSearchViewModel(state: .fetching))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Fetching State")
            
            SearchStateDisplayer(
                viewModel: MockSearchViewModel(
                    state: .fetched([
                        Record(text: "Apple"),
                        Record(text: "Banana"),
                        Record(text: "Apple3"),
                        Record(text: "Banana4"),
                        Record(text: "Apple5"),
                        Record(text: "Banana6")
                        ])
                )
            )
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Fetched Records State")
            
            SearchStateDisplayer(viewModel: MockSearchViewModel(state:.failed("No records found")))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Failed State")
        }
    }
}
