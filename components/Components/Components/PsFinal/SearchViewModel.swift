//
//  SearchViewModel.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import Foundation
import SwiftUI
import Combine

enum SearchState {
    case idle
    case fetching
    case fetched([Record])  // Contains an array of fetched records
    case failed(String)     // Contains an error message
}

class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var selectedRecords: [Record] = []
    @Published var searchState: SearchState = .idle
    
    
    private var queryCancellable: AnyCancellable?
    
    // Dummy data for demonstration
    private var allRecords = [
        Record(text: "Apple"),
        Record(text: "Banana"),
        Record(text: "Alabama"),
        Record(text: "Apricot"),
        Record(text: "Alphanso"),
        Record(text: "Alien")
        // Add more records as needed
    ]
    
    init() {
        queryCancellable = $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] in self?.search(query: $0) }
    }
    
    // Add a method to cancel the subscription
    func cancelQuerySubscription() {
        queryCancellable?.cancel()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func search(query: String) {
        debugPrint("<<<< perform search for \(query)")
        guard !query.isEmpty else {
            searchState = .idle
            return
        }
        
        searchState = .fetching
        // Simulate asynchronous search
        
        let baseUrl = "https://restcountries.com/v3.1/name/"
        guard let url = URL(string: baseUrl + query) else {
            return
        }
        debugPrint("url is \(url)")
        
        
        /*URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let countries = try? JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    if let unwrappedCountries = countries,
                       !unwrappedCountries.isEmpty{
                        self.searchState = .fetched(unwrappedCountries)
//                        allRecords = unwrappedCountries
                    }else{
                        self.searchState = .failed("No records found")
                    }
//                    completion(countries ?? [])
                }
            }
        }.resume()*/
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Filter out selected records
            let results = self.allRecords.filter { record in
                !self.selectedRecords.contains(where: { $0.id == record.id }) &&
                record.text.lowercased().contains(query.lowercased())
            }
            debugPrint("<<<< searched results \(results)")
            if results.isEmpty {
                self.searchState = .failed("No records found")
            } else {
                self.searchState = .fetched(results)
            }
        }
    }
    
    func selectRecord(_ record: Record) {
        debugPrint("<<<< select record \(record)")
        selectedRecords.append(record)
        searchState = .idle  // Optionally reset the search state
        query =  ""
    }
    
    func removeRecord(_ record: Record) {
        debugPrint("<<<< remove record \(record)")
        selectedRecords.removeAll { $0.id == record.id }
    }
    
    func clearAllSelections(){
        selectedRecords.removeAll()
    }
}
