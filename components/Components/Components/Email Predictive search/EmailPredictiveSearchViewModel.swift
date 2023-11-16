//
//  EmailPredictiveSearchViewModel.swift
//  Components
//
//  Created by Ankit Sachan on 12/11/23.
//

import Foundation

class EmailPredictiveSearchViewModel : ObservableObject {
    @Published var query = ""
    @Published var selectedRecords: [Record] = []
}
