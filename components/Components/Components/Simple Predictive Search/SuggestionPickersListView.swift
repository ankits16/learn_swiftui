import SwiftUI

struct SuggestionItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
}

struct SuggestionPicker: View {
    @State private var searchText = ""
    @State private var suggestions: [SuggestionItem] = []
    @State private var selectedItems: [SuggestionItem] = []
    @State private var isShowingSuggestions = false
    var allSuggestions: [SuggestionItem]
    private let rowHeight: CGFloat = 44

    var body: some View {
        VStack {
            // 1. TextField
            TextField("Type something...", text: $searchText, onEditingChanged: { isEditing in
                withAnimation {
                    self.isShowingSuggestions = isEditing && !self.searchText.isEmpty
                }
            })
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .onChange(of: searchText) { newValue in
                suggestions = search(newValue)
            }
            // 2. Overlay for Suggestion List
            .overlay(
                Group {
                    if isShowingSuggestions {
                        SuggestionsListView(
                            suggestions: $suggestions,
                            searchText: $searchText,
                            selectedItems: $selectedItems,
                            isShowingSuggestions: $isShowingSuggestions
                        )
                            .frame(maxWidth: .infinity, maxHeight: calculateHeight())
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            // Adjust the position as needed
                            .offset(x: 0, y: -(60)) // Half height of the list plus padding
                            .transition(.opacity.combined(with: .offset(y: -20)))
                    }
                }, alignment: .bottomLeading
            )

            // 3. Selected Options List
            VStack {
                ForEach(selectedItems, id: \.self) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        Button(action: {
                            self.deselect(item: item)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        
    }

    func search(_ query: String) -> [SuggestionItem] {
        let retval = allSuggestions.filter { $0.title.lowercased().contains(query.lowercased()) }
        isShowingSuggestions =  !retval.isEmpty
        return retval
    }

    func select(suggestion: SuggestionItem) {
        selectedItems.append(suggestion)
        searchText = ""
        withAnimation {
            isShowingSuggestions = false
        }
    }

    func deselect(item: SuggestionItem) {
        selectedItems.removeAll { $0.id == item.id }
    }

    func calculateHeight() -> CGFloat {
        let totalHeight = CGFloat(suggestions.count) * rowHeight
        let maxHeight = UIScreen.main.bounds.height / 3 // Maximum to a third of the screen
        return min(totalHeight, maxHeight)
    }
}

struct SuggestionsListView: View {
    @Binding var suggestions: [SuggestionItem]
    @Binding var searchText: String
    @Binding var selectedItems: [SuggestionItem]
    @Binding var isShowingSuggestions: Bool
    let rowHeight: CGFloat = 44
    var body: some View {
            VStack {
                ForEach(suggestions) { suggestion in
                    Text(suggestion.title)
                        .frame(height: rowHeight)
                        .onTapGesture {
                            select(suggestion: suggestion)
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: calculateHeight())
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
    
    func calculateHeight() -> CGFloat {
            let totalHeight = CGFloat(suggestions.count) * rowHeight
            // You may want to set a maximum height constraint
            // to prevent the list from becoming too long
            let maxHeight = UIScreen.main.bounds.height / 2
            return min(totalHeight, maxHeight)
        }
    
    func select(suggestion: SuggestionItem) {
        selectedItems.append(suggestion)
        searchText = ""
        isShowingSuggestions = false
    }
}

// Usage in your main view
struct ContentView: View {
    // Sample data for the first SuggestionPicker
    let firstSuggestions = [
        SuggestionItem(title: "Apple"),
        SuggestionItem(title: "Apricot"),
        SuggestionItem(title: "Avocado"),
        // Add more suggestions as needed
    ]

    // Sample data for the second SuggestionPicker
    let secondSuggestions = [
        SuggestionItem(title: "Carrot"),
        SuggestionItem(title: "Cucumber"),
        SuggestionItem(title: "Corn"),
        SuggestionItem(title: "Apple"),
        SuggestionItem(title: "Apricot"),
        SuggestionItem(title: "Avocado"),
        SuggestionItem(title: "Apple"),
        SuggestionItem(title: "Apricot"),
        SuggestionItem(title: "Avocado"),
        SuggestionItem(title: "Apple"),
        SuggestionItem(title: "Apricot"),
        SuggestionItem(title: "Avocado"),
        // Add more suggestions as needed
    ]

    var body: some View {
        VStack {
            Text("EmailPredictiveSearch")
            Spacer(minLength: 100)
            EmailPredictiveSearch(
                viewModel: SearchViewModel<Country>(
                    fetchResults: { q, completion in
                        let baseUrl = "https://restcountries.com/v3.1/name/"
                        guard let url = URL(string: baseUrl + q) else {
                            return
                        }
                        debugPrint("url is \(url)")
                        
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            var countries: [Country] = []
                            
                            if let data = data {
                                do {
                                    // Parse the JSON data
                                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                                        for jsonObject in jsonArray {
                                            countries.append(Country(jsonObject))
                                        }
                                    }
                                } catch {
                                    print("JSON parsing error: \(error)")
                                }
                            }
                            
                            DispatchQueue.main.async {
                                completion(countries)
                            }
                        }.resume()
                        /*URLSession.shared.dataTask(with: url) { data, response, error in
                            if let data = data {
                                let countries = try? JSONDecoder().decode([Country].self, from: data)
                                DispatchQueue.main.async {
                                    completion(countries ?? [])
                                }
                            }
                        }.resume()*/
                    }
                )) { _ in
                    
                }
//            SampleTextfield()
//            EmailBubblesView()
            Divider() // Visual separator, if needed
//
//            EmailPredictiveSearch(viewModel: SearchViewModel()) { _ in
//
//            }
//            // First SuggestionPicker
//            SuggestionPicker(allSuggestions: firstSuggestions)
//                .padding()
//
//            Divider() // Visual separator, if needed
//
//            // Second SuggestionPicker
//            SuggestionPicker(allSuggestions: secondSuggestions)
//                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
