//
//  SearchView4.swift
//  Components
//
//  Created by Ankit Sachan on 09/11/23.
//

import SwiftUI

struct SearchView4: View {
    @State private var searchText = ""
    @State private var showSuggestions = false
    
    // Sample data to mimic suggestion engine
    let data = [
        "Apple", "Banana", "Cherry", "Date", "Eggfruit", "Fig", "Grape", "Honeydew"
    ]
    
    // A computed property to filter suggestions based on search text
    var filteredData: [String] {
        guard !searchText.isEmpty else { return [] }
        return data.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack {
                    TextField("Type something...", text: $searchText)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding()
                        .onChange(of: searchText) { newValue in
                            showSuggestions = !newValue.isEmpty
                        }
                    Spacer() // Pushes all content to the top
                }
                
                // Suggestions overlay
                if showSuggestions {
                    VStack {
                        // Empty view to push down the suggestions
                        Rectangle().fill(Color.clear).frame(height: geometry.safeAreaInsets.top + 50)
                        
                        // Suggestions list
                        ScrollView(.vertical) {
                            VStack(alignment: .leading) {
                                ForEach(filteredData, id: \.self) { suggestion in
                                    Text(suggestion)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .onTapGesture {
                                            self.searchText = suggestion
                                            self.showSuggestions = false
                                        }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 400) // Set the maximum height here
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.opacity) // This adds a fade-in/fade-out effect
                        .zIndex(1) // Ensures the overlay is above all other content
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
        .border(.orange)
    }
}

struct SearchView4_Previews: PreviewProvider {
    static var previews: some View {
        SearchView4()
    }
}
