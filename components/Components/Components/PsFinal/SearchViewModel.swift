//
//  SearchViewModel.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import Foundation
import SwiftUI
import Combine

enum SearchState<T : Equatable> : Equatable{
    case idle
    case fetching
    case fetched([T])  // Contains an array of fetched records
    case failed(String)     // Contains an error message
    
    static func ==(lhs: SearchState<T>, rhs: SearchState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.fetching, .fetching):
            return true
        case (.fetched(let a), .fetched(let b)):
            return a == b
        case (.failed(let a), .failed(let b)):
            return a == b
        default:
            return false
        }
    }
}

class SearchViewModel<Item : BubbleItemProtocol>: ObservableObject {
    @Published var query = ""
    @Published var selectedRecords: [Item] = []
    @Published var searchState: SearchState<Item> = .idle
    
    
    private var queryCancellable: AnyCancellable?
    var fetchResults: (String, @escaping ([Item]) -> Void) -> Void

    var searchedRecords : [Item]?{
        if case .fetched(let records) = searchState{
            return records
        }else{
            return nil
        }
    }
    
    init(fetchResults: @escaping (String, @escaping ([Item]) -> Void) -> Void) {
        self.fetchResults = fetchResults
        queryCancellable = $query
                    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .sink { [weak self] in self?.performSearch(query: $0) }
        //        $query
        //                    .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        //                    .removeDuplicates()
        //                    .flatMap { [weak self] query in
        //                        self?.searchState = .fetching
        //                        return searchService(query)
        //                            .catch { _ in Just([]) }
        //                            .map { SearchState.fetched($0) }
        //                    }
        //                    .assign(to: &$searchState)
    }
    
    // Add a method to cancel the subscription
    func cancelQuerySubscription() {
        queryCancellable?.cancel()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchState = .idle
            return
        }
        searchState = .fetching
        fetchResults(query) { [weak self] results in
            DispatchQueue.main.async {
                if results.isEmpty {
                    self?.searchState = .failed("No results found")
                } else {
                    self?.searchState = .fetched(results)
                }
            }
        }
    }
    
    func selectRecord(_ record: Item) {
        debugPrint("<<<< select record \(record)")
        selectedRecords.append(record)
        searchState = .idle  // Optionally reset the search state
        query =  ""
    }
    
    func removeRecord(_ record: Item) {
        debugPrint("<<<< remove record \(record)")
        selectedRecords.removeAll { $0.id == record.id }
    }
    
    func clearAllSelections(){
        selectedRecords.removeAll()
    }
    
    func selectFirstRecordIfAAvailableAsUserPressedEnter(){
        if let firstRecord = searchedRecords?.first{
            selectRecord(firstRecord)
        }
    }
    
    func dismiss(){
        searchState = .idle  // Optionally reset the search state
        query =  ""
    }
}
