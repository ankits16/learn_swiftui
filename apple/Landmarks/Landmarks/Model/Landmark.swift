//
//  Landmark.swift
//  Landmarks
//
//  Created by Ankit Sachan on 04/10/23.
//

import Foundation
import SwiftUI

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool
    var isFeatured: Bool
    
    enum Category : String, CaseIterable, Codable{
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }
    var category : Category
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}
