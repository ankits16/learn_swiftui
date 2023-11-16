import SwiftUI

struct CustomDropdown: View {
    @State private var isDropdownOpen: Bool = false
    @State private var selectedValue: String = "Select an option"
    let options: [String] = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: {
                isDropdownOpen.toggle()
            }) {
                HStack {
                    Text(selectedValue)
                    Spacer()
                    Image(systemName: "arrow.down")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }

            if isDropdownOpen {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedValue = option
                            isDropdownOpen = false
                        }) {
                            Text(option)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct CustomDropdown_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropdown()
    }
}
