// SearchView.swift
// Components
// Created by Ankit Sachan on 18/10/23.

import SwiftUI

func fetchCountries(query: String, completion: @escaping ([Country]) -> Void) {
    let baseUrl = "https://restcountries.com/v3.1/name/"
    guard let url = URL(string: baseUrl + query) else {
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
}

struct Country: Codable, Identifiable, Hashable, Displayable, BubbleItemProtocol {
    var id: UUID = UUID()
    
    var text: String
    
//    var id: String {
//        return name.common
//    }
    var name: Name
    struct Name: Codable, Hashable {
        var common: String
    }
    var displayName: String{
        return self.name.common
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @State private var countries: [Country] = []
    @Binding var selectedCountries: [Country]
    
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchState: SearchState = .idle
    @State private var scrollToCountryId: String? = nil
    @State private var isPopoverVisible = false
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    enum SearchState {
        case idle, fetching, noResults, results
    }
    let countryBubbleHeight: CGFloat = 40.0
    var body: some View {
        VStack() {
            VStack (alignment: .leading){
                
                
                // Search field
                TextField("Search countries...", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding([.leading, .trailing], 10)
                    .focused($isSearchFieldFocused)
                    .onChange(of: searchText, perform: { value in
                        if !value.isEmpty {
                            isPopoverVisible = true
                            loadCountries()
                        }
                    })
                    .popover(isPresented: $isPopoverVisible) {
                        ZStack(alignment: .topLeading) {
                            // Message box
                            switch searchState {
                            case .idle where isSearchFieldFocused:
                                Text("Type text to search country")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(8)
                                    .padding([.leading, .trailing], 10)
                            case .fetching:
                                HStack {
                                    Text("Fetching record...")
                                    Spacer()
                                    ProgressView()
                                }
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                                .padding([.leading, .trailing], 10)
                                .frame(minWidth: 300, alignment: .topLeading)
                            case .noResults:
                                Text("No records found")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(8)
                                    .padding([.leading, .trailing], 10)
                            default:
                                EmptyView()
                            }
                            
                            // Results list
                            if (!countries.isEmpty){
                                List(countries) { country in
                                    Button(action: {
                                        if let _ = selectedCountries.firstIndex(where: { $0.id == country.id }) {
                                            // If country is already selected, remove it
                                            selectedCountries.removeAll { $0.id == country.id }
                                        } else {
                                            // Add country to selected list and clear the search results and search text
                                            selectedCountries.append(country)
                                            debugPrint("<<<<<< added country \(selectedCountries.count)")
                                            searchText = ""
                                            countries = []
                                        }
                                        isPopoverVisible = false
                                    }) {
                                        Text(country.name.common)
                                            .background(selectedCountries.contains(where: { $0.id == country.id }) ? Color.blue.opacity(0.3) : Color.clear)
                                    }
                                }
                                .frame(minWidth: 300, minHeight: 400, alignment: .topLeading)
                                //                                .frame(maxWidth: 400, maxHeight: 500)
                                .border(.red)
                            }
                        }
                        .frame(maxWidth: 400, maxHeight: 500)
                        .presentationCompactAdaptation(.popover)
                        
                    }
                
                if !selectedCountries.isEmpty{
                    // Selected countries bubbles
                    ScrollViewReader { reader in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(selectedCountries, id: \.id) { country in
                                    HStack(spacing: 5) {
                                        Text(country.name.common)
                                            .padding(.all, 10)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                        
                                        Button(action: {
                                            if let index = selectedCountries.firstIndex(where: { $0.id == country.id }) {
                                                selectedCountries.remove(at: index)
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.blue)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }
                            
                            .padding(.horizontal, 10)
                            
                        }
                        .clipped()
                        .frame(
                            width: .infinity,
                            height:min(CGFloat(selectedCountries.count) * countryBubbleHeight, 400)
                        )
                        .onChange(of: selectedCountries) { newValue in
                            if let lastCountry = newValue.last {
                                withAnimation {
                                    reader.scrollTo(lastCountry.id, anchor: .bottom)
                                }
                            }
                        }
                        .border(.orange)
                    }
                }
                Spacer(minLength: keyboardResponder.currentHeight) // Push content up
                
            }
            
            //            Spacer()
        }
    }
    
    func loadCountries() {
        searchState = .fetching
        self.countries = []
        fetchCountries(query: searchText) { newCountries in
            debugPrint("<<<<< load countries \(newCountries.count)")
            self.countries = newCountries
            if newCountries.isEmpty {
                searchState = .noResults
            } else {
                searchState = .results
            }
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchViewWr()
    }
    
    
    struct SearchViewWr: View {
        @State var previewSelectedCountries: [Country] = []
        var body: some View {
            SearchView(selectedCountries: $previewSelectedCountries)
        }
    }
}
