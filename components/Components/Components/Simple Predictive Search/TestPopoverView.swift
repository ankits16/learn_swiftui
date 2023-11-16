//
//  TestPopoverView.swift
//  Components
//
//  Created by Ankit Sachan on 22/10/23.
//

import SwiftUI

struct TestPopoverView: View {
    @State private var showingPopover = false
    var body: some View {
        Button("Show Menu") {
                    showingPopover = true
                }
                .popover(isPresented: $showingPopover) {
                    Text("Your content here")
                        .font(.headline)
                        .padding()
                        .frame(width: 300, height: 300)
                        .presentationCompactAdaptation(.popover)
                }
    }
}

struct TestPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        TestPopoverView()
    }
}
