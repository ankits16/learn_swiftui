//
//  SearchView3.swift
//  Components
//
//  Created by Ankit Sachan on 09/11/23.
//

import SwiftUI

struct SearchView3<DataItem: Identifiable & Equatable & Displayable, Content: View>: View {
    @State private var searchText = ""
    @State private var results: [DataItem] = []
    @Binding var selectedItems: [DataItem]
    
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchState: SearchState = .idle
    @State private var isPopoverVisible = false
    
    enum SearchState {
        case idle, fetching, noResults, results
    }
    
    private let dataItemBubbleHeight: CGFloat = 40.0
    var fetchResults: (String, @escaping ([DataItem]) -> Void) -> Void
    var content: (DataItem, @escaping () -> Void) -> Content
    
    init(
        selectedItems: Binding<[DataItem]>,
        fetchResults: @escaping (String, @escaping ([DataItem]) -> Void) -> Void,
        content: @escaping (DataItem, @escaping () -> Void) -> Content) {
            self._selectedItems = selectedItems
            self.fetchResults = fetchResults
            self.content = content
        }
    
    var body: some View {
        VStack() {
            VStack (alignment: .leading){
                
                // Search field
                TextField("Search...", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding([.leading, .trailing], 10)
                    .focused($isSearchFieldFocused)
                    .onChange(of: searchText, perform: { value in
                        if !value.isEmpty {
                            self.isPopoverVisible = true
                            loadResults()
                        }
                    })
                    .overlay(
                        Group {
                            if isPopoverVisible{
                                ZStack(alignment: .topLeading) {
                                    // Message box
                                    switch searchState {
                                    case .idle where isSearchFieldFocused:
                                        Text("Type to search")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .background(Color(.systemGray5))
                                            .cornerRadius(8)
                                            .padding([.leading, .trailing], 10)
                                    case .fetching:
                                        HStack {
                                            Text("Fetching...")
                                            Spacer()
                                            ProgressView()
                                        }
                                        .padding()
                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                        .padding([.leading, .trailing], 10)
                                    case .noResults:
                                        Text("No results found")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .background(Color(.systemGray5))
                                            .cornerRadius(8)
                                            .padding([.leading, .trailing], 10)
                                    default:
                                        EmptyView()
                                    }
                                    
                                    // Results list
                                    if (!results.isEmpty){
                                        List(results) { item in
                                            Button(action: {
                                                if let _ = selectedItems.firstIndex(where: { $0.id == item.id }) {
                                                    // If already selected, remove it
                                                    selectedItems.removeAll { $0.id == item.id }
                                                } else {
                                                    // Add to selected list and clear the search results and search text
                                                    selectedItems.append(item)
                                                    debugPrint("selecetd item = \(selectedItems)")
                                                    searchText = ""
                                                    results = []
                                                }
                                                self.isPopoverVisible = false
                                            }) {
                                                Text(item.displayName)
                                                    .background(selectedItems.contains(where: { $0.id == item.id }) ? Color.blue.opacity(0.3) : Color.clear)
                                            }
                                        }
                                        .frame(minWidth: 300, minHeight: 100, alignment: .topLeading)
                                        .border(.red)
                                    }
                                }
                                .frame(maxWidth: 400, maxHeight: 500)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                // Adjust the position as needed
                                .offset(x: 0, y: -(60)) // Half height of the list plus padding
                                .transition(.opacity.combined(with: .offset(y: -20)))
                            }
                        }
                        , alignment: .bottomLeading
                    )
                
                //                    .popover(isPresented: $isPopoverVisible) {
                //
                //                        .presentationCompactAdaptation(.popover)
                //                    }
                
                if !selectedItems.isEmpty{
                    // Selected countries bubbles
                    ScrollViewReader { reader in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(selectedItems, id: \.id) { country in
                                    HStack(spacing: 5) {
                                        content(country){
                                            if let index = selectedItems.firstIndex(where: { $0.id == country.id }) {
                                                selectedItems.remove(at: index)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            .padding(.horizontal, 10)
                            
                        }
                        //                        .clipped()
                        //                        .frame(
                        ////                            width: .infinity,
                        //                            height:min(CGFloat(selectedItems.count) * dataItemBubbleHeight, 100)
                        //                        )
                        .onChange(of: selectedItems) { newValue in
                            if let lastCountry = newValue.last {
                                withAnimation {
                                    reader.scrollTo(lastCountry.id, anchor: .bottom)
                                }
                            }
                        }
                        .border(.orange)
                    }
                }else{
                    Text("<<<<< no item selected yet \(Date.now.timeIntervalSince1970) c = \(selectedItems.count)")
                }
                Spacer()
            }
            
        }
    }
    
    func loadResults() {
        searchState = .fetching
        self.results = []
        fetchResults(searchText) { newResults in
            self.results = newResults
            if newResults.isEmpty {
                searchState = .noResults
            } else {
                searchState = .results
            }
        }
    }
}

//protocol Displayable {
//    var displayName: String { get }
//}

struct ExampleDataItem: Identifiable, Equatable, Displayable {
    let id: UUID
    let displayName: String
}

struct SearchView3_Previews: PreviewProvider {
    static var previews: some View {
        SearchView3<ExampleDataItem, Text>(
            selectedItems: .constant([]),
            fetchResults: { searchText, completion in
                // This is just a mock fetch to provide example data items.
                // In a real app, you might hit an API or search a database.
                let results = [
                    ExampleDataItem(id: UUID(), displayName: "Apple"),
                    ExampleDataItem(id: UUID(), displayName: "Avacado"),
                    ExampleDataItem(id: UUID(), displayName: "Appricot")
                ].filter { $0.displayName.contains(searchText) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    completion(results)
                }
            },
            content: { item, removeItem in
                Text(item.displayName)
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .onTapGesture {
                        removeItem()
                    } as! Text
            }
        )
        .frame(width: 400, height: 600)
        .padding()
    }
}
