//
//  Mocks.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import Foundation
import Combine

/**
 Mock Model for predictive search
 */
class MockSearchViewModel: SearchViewModel<Record> {
    
    init(state: SearchState<Record>) {
        super.init() { q, completion in
            debugPrint("<<<<<< called")
            completion(
                [Record(text: "Apple")]
            )
        }
        self.searchState = state
        cancelQuerySubscription()
    }
}

class MockSearchViewModelWithSelectedRecords: SearchViewModel<Record> {
    init(_ selectedRecords : [Record]) {
        super.init() { q, completion in
            debugPrint("<<<<<< called")
            completion(
                [Record(text: "Apple")]
            )
        }
        self.selectedRecords = selectedRecords
//        cancelQuerySubscription()
    }
}
