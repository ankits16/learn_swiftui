//
//  FetchedRecordsView.swift
//  Components
//
//  Created by Ankit Sachan on 11/11/23.
//

import SwiftUI

/**
 This is the view which show list of suggestions to predictive view
 */
struct FetchedRecordsView: View {
    @ObservedObject var viewModel: SearchViewModel
//    var records: [Record]
    private let rowHeight1: CGFloat = 44 // Define your standard row height here
    private var records : [Record]?{
        if case .fetched(let records) = viewModel.searchState{
            return records
        }else{
            return nil
        }
    }
    private func calculateListHeight() -> CGFloat {
        guard let unwrappedRecord = records else{ return 0}
        var totalHeight: CGFloat = 0
        
        for record in unwrappedRecord {
            let estimatedHeight = estimateRowHeight(for: record)
            totalHeight += estimatedHeight
            if totalHeight >= 400 {
                return 400
            }
        }
        
        return totalHeight
    }
    
    private func estimateRowHeight(for record: any BubbleItemProtocol) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17) // Example font size
        let padding: CGFloat = 20 // Total vertical padding
        
        // Estimate the size of the text
        let text = record.text as NSString
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 40, height: .infinity)
        let textRect = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return textRect.height + padding
    }
    
    
    var body: some View {
        if let unwrappedRecords = records{
            List(unwrappedRecords, id: \.id) { record in
                    Text(record.text)
                    .onTapGesture {
                        viewModel.selectRecord(record)
                    }
            }
            
            .listStyle(PlainListStyle())
            .frame(width: UIScreen.main.bounds.width - 40, height: calculateListHeight())
            .cornerRadius(10)  // Rounded corners
            .shadow(radius: 10)
        }else{
            Text("Invalid state")
        }
        
    }
}

struct FetchedRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FetchedRecordsView(
                viewModel: MockSearchViewModel(state: .fetched(
                    [
                        Record(text: "First1 \n new line \n bbbbb \n vvvvv"),
                        Record(text: "Second"),
                        Record(text: "Third"),
                        Record(text: "Fourth"),
                        Record(text: "Fifth"),
                        Record(text: "Sixth"),
                        Record(text: "Seventh"),
                        Record(text: "Eighth")
                    ]
                )
                )
            )
            .previewDisplayName("No record selected")
            
            FetchedRecordsView(
                viewModel: MockSearchViewModel(state: .fetching)
            )
            .previewDisplayName("When accessed via invalid state")
        }
    }
}
