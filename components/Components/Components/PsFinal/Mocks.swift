//
//  Mocks.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import Foundation

/**
 Mock Model for predictive search
 */
class MockSearchViewModel: SearchViewModel {
    init(state: SearchState) {
        super.init()
        self.searchState = state
        cancelQuerySubscription()
    }
}

class MockSearchViewModelWithSelectedRecords: SearchViewModel {
    init(_ selectedRecords : [Record]) {
        super.init()
        self.selectedRecords = selectedRecords
//        cancelQuerySubscription()
    }
}
