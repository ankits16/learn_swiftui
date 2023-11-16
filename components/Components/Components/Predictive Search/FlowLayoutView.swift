import SwiftUI

struct WrappingTextView: View {
    let items = [
        BubbleItem(text: "apple"),
        BubbleItem(text: "banana"),
        BubbleItem(text: "cherry"),
        BubbleItem(text: "date"),
        BubbleItem(text: "elderberry"),
        BubbleItem(text: "fig"),
        BubbleItem(text: "Help me undertand why this text is soooooooooooooooooooooo long"),
        BubbleItem(text: "raspberry"),
        BubbleItem(text: "xigua"),
        BubbleItem(text: "yellow"),
        BubbleItem(text: "This is a very long text \n multine as well")
    ]

    @State private var totalHeight: CGFloat = 0

    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    WrappingRow(items: items) { height in
                        self.totalHeight = height
                    }
                }
                .frame(height: totalHeight)
                Button(action: {
//                    removeAction?()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.black)
                })
            }
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .frame(maxHeight: 200)
        .background(Color.yellow)
    }
}




struct WrappingTextView_Previews: PreviewProvider {
    static var previews: some View {
        WrappingTextView()
    }
}
