//
//  ContentView.swift
//  Components
//
//  Created by Ankit Sachan on 17/10/23.
//

import SwiftUI

struct AssignmentForm : View{
    @State private var isOrangeRectangleVisible = false
    @State private var selectedCountries: [Country] = []
    @State private var messageText: String = ""
    var body: some View {
        let _ = Self._printChanges()
        NavigationView {
            VStack(alignment: .leading) {
                Text("Message") // Label
                    .font(.title)
                    .padding(.top, 20)
                
                PlaceholderTextEditor(text: $messageText, placeholder: "place holder goes here") // TextView
                    .frame(height: 100) // Set the height to 100 points
                    .padding()
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
                //                .padding(.horizontal, 20)
                
                Text("Assign To") // Label
                    .font(.title)
                    .padding(.top, 20)
                
                SearchView3(
                    selectedItems: $selectedCountries,
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
                //                SearchView(selectedCountries: $selectedCountries)
                //                    .border(.red)
                //                .padding(.horizontal, 20)
                Spacer()
                Button("Assign") {
                    for country in selectedCountries {
                        print(country.name.common)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundColor(.white)
                .background(Color.green)
                Spacer().frame(height: 10)
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }
}

import SwiftUI

//struct SearchTextField: View {
//    @Binding var searchText: String
//    var suggestions: [String]
//    var onSuggestionSelected: (String) -> Void
//    
//    @State private var showSuggestions = false
//    
//    var body: some View {
//        SuggestionPickersListView()
//    }
//}
//
//struct SuggestionsListView: View {
//    var suggestions: [String]
//    var onSuggestionSelected: (String) -> Void
//    
//    var body: some View {
//        ScrollView(.vertical) {
//            VStack(alignment: .leading) {
//                ForEach(suggestions, id: \.self) { suggestion in
//                    Text(suggestion)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color.white)
//                        .onTapGesture {
//                            onSuggestionSelected(suggestion)
//                        }
//                }
//            }
//        }
//        .frame(maxHeight: 400) // Set the maximum height here
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
//        .transition(.opacity) // This adds a fade-in/fade-out effect
//        .zIndex(1) // Ensures the overlay is above all other content
//    }
//}

//// Usage in ContentView
//struct ContentView: View {
//    @State private var searchText = ""
//    @State private var searchText2 = ""
//    let data = ["Apple", "Banana", "Cherry", "Date", "Eggfruit", "Fig", "Grape", "Honeydew"]
//
//    var body: some View {
//        VStack{
//            SearchTextField(searchText: $searchText, suggestions: data, onSuggestionSelected: { suggestion in
//    //            searchText = suggestion
//            })
//            .padding() // Add padding here if needed
//            SearchTextField(searchText: $searchText2, suggestions: data, onSuggestionSelected: { suggestion in
//    //            searchText = suggestion
//            })
//            .padding() // Add padding here if needed
//        }
//
//    }
//}




//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
