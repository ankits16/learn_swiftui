//
//  DataModel.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import Foundation

/**
 A simple record that will be displayed in predicitve search 
 */
struct Record : BubbleItemProtocol, Identifiable, Equatable{
    var text: String
    
    var id: UUID = UUID()
//    let name: String
    // Add other properties as needed
}
