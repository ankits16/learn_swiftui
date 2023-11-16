//
//  SearchView_Final.swift
//  Components
//
//  Created by Ankit Sachan on 20/10/23.
//

import SwiftUI
import Combine

protocol Displayable {
    var displayName: String { get }
}

struct SearchView2<DataItem: Identifiable & Equatable & Displayable, Content: View>: View {
    @State private var searchText = ""
    @State private var results: [DataItem] = []
    @Binding var selectedItems: [DataItem]
    
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchState: SearchState = .idle
    
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
                        .clipped()
                        .frame(
                            width: .infinity,
                            height:min(CGFloat(selectedItems.count) * dataItemBubbleHeight, 100)
                        )
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
                // Search field
                TextField("Search...", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding([.leading, .trailing], 10)
                    .focused($isSearchFieldFocused)
                    .onChange(of: searchText, perform: { value in
                        if !value.isEmpty {
                            loadResults()
                        }
                    })
                
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
                            }) {
                                Text(item.displayName)
                                    .background(selectedItems.contains(where: { $0.id == item.id }) ? Color.blue.opacity(0.3) : Color.clear)
                            }
                        }
                        .border(.red)
                    }
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



struct SearchView_Previews2: PreviewProvider {
    
    static var previews: some View {
        SearchViewWrapperForPreview()
    }
    
    struct SearchViewWrapperForPreview : View{
        @State var previewSelectedCountries: [Country] = []
        var body: some View {
            SearchView2(
                selectedItems: $previewSelectedCountries,
                fetchResults: { q, completion in
                    let baseUrl = "https://restcountries.com/v3.1/name/"
                    guard let url = URL(string: baseUrl + q) else {
                        return
                    }
                    debugPrint("url is \(url)")
                    
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            let countries = try? JSONDecoder().decode([Country].self, from: data)
                            DispatchQueue.main.async {
                                completion(countries ?? [])
                            }
                        }
                    }.resume()
                },
                content: { country, action in
                    HStack {
                        Text(country.name.common)
                            .padding(.all, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        
                        Button(action: action) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                        }
                    }
                })
            .border(.red)
        }
    }
}
