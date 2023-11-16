//
//  BubbleView.swift
//  Components
//
//  Created by Ankit Sachan on 18/10/23.
//

import SwiftUI

// 1. Create a ViewSizeKey PreferenceKey
struct ViewSizeKey: PreferenceKey {
    typealias Value = CGSize
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct BubbleView: View {
    var id : UUID{
        return item.id
    }
    var item: any BubbleItemProtocol
    var removeAction: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 8) {
            Text(item.text)
                .foregroundColor(Color.white)
            Button(action: {
                removeAction?()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.white)
            })
        }
        .padding(.all, 8)
        .background(GeometryReader { geometry in
                    Color.gray.preference(key: ViewSizeKey.self, value: geometry.size)
                })
        .cornerRadius(12)
    }
}


struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(item: BubbleItem(text: "Help me \n undertand why this text is soooooooooooooooooooooo long"))
    }
}

