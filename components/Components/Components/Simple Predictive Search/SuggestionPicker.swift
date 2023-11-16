////
////  SuggestionPicker.swift
////  Components
////
////  Created by Ankit Sachan on 09/11/23.
////
//
//import SwiftUI
//
//struct SuggestionItem: Identifiable {
//    var id = UUID()
//    var title: String
//}
//
//struct SuggestionPicker: View {
//    @State private var searchText = ""
//        @State private var suggestions = [SuggestionItem]()
//        @State private var selectedItems = [SuggestionItem]()
//        @State private var isShowingSuggestions = false
//        
//        var allSuggestions: [SuggestionItem]
//
//        var body: some View {
//            VStack {
//                // 3. Selected Options List
//                VStack {
//                    ForEach(selectedItems) { item in
//                        HStack {
//                            Text(item.title)
//                            Spacer()
//                            Button(action: {
//                                self.deselect(item: item)
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//
//                ZStack(alignment: .topLeading) {
//                    // 1. TextField
//                    TextField("Type something...", text: $searchText, onEditingChanged: { isEditing in
//                        self.isShowingSuggestions = isEditing && !self.searchText.isEmpty
//                    }, onCommit: {
//                        self.isShowingSuggestions = false
//                    })
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray, lineWidth: 1)
//                    )
//                    .onChange(of: searchText) { newValue in
//                        self.suggestions = self.search(newValue)
//                    }
//
//                    // 2. Suggestion List
//                    if isShowingSuggestions {
//                        ScrollView {
//                            VStack(alignment: .leading) {
//                                ForEach(suggestions) { suggestion in
//                                    Text(suggestion.title)
//                                        .padding()
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .background(Color.white)
//                                        .onTapGesture {
//                                            self.select(suggestion: suggestion)
//                                        }
//                                }
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
//                        .border(Color.gray, width: 1)
//                        // Adjust the offset to position the suggestion list correctly.
//                        .offset(y: 60)
//                    }
//                }
//            }
//        }
//    func search(_ query: String) -> [SuggestionItem] {
//        // This is where the search logic will be implemented.
//        // For now, it's just a simple filter.
//        return allSuggestions.filter { $0.title.lowercased().contains(query.lowercased()) }
//    }
//    
//    func select(suggestion: SuggestionItem) {
//        selectedItems.append(suggestion)
//        searchText = ""
//        isShowingSuggestions = false
//    }
//    
//    func deselect(item: SuggestionItem) {
//        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
//            selectedItems.remove(at: index)
//        }
//    }
//}
//
//struct SuggestionPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        SuggestionPicker(allSuggestions: [
//            SuggestionItem(title: "Apple"),
//            SuggestionItem(title: "Banana"),
//            SuggestionItem(title: "Cherry")
//        ])
//    }
//}
