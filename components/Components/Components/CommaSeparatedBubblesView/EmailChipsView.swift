import SwiftUI
import UIKit

struct EmailBubble: Identifiable, Hashable {
    let id: UUID = UUID()
    var email: String
}

// Define the UIViewRepresentable to wrap a UITextField
struct FocusableTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onCommit: (() -> Void)?
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FocusableTextField
        
        init(_ parent: FocusableTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
        
        // Detects when the space button is pressed
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == " " && !textField.text!.isEmpty {
                parent.onCommit?()
                return false
            }
            return true
        }
        
        // Handles the return button on the keyboard
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Dismiss the keyboard
            parent.onCommit?() // Convert text to bubble
            return false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done // Set the return key type to 'Done'
        textField.placeholder = placeholder
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct EmailBubblesView: View {
    @State private var emails: [EmailBubble] = []
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(emails, id: \.self) { bubble in
                        HStack {
                            Text(bubble.email)
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                            Button(action: {
                                self.delete(bubble: bubble)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    }
                    FocusableTextField(text: $inputText, placeholder: "Enter emails", onCommit: {
                        self.addEmail()
                    })
                    .frame(minHeight: 40) // Set the minimum height of the text field
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onTapGesture {
                // Logic to focus the text field
            }
            .border(.orange)
        }
    }
    
    private func delete(bubble: EmailBubble) {
        emails.removeAll { $0.id == bubble.id }
    }
    
    private func addEmail() {
        let newEmail = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(newEmail) {
            emails.append(EmailBubble(email: newEmail))
            inputText = ""
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Add your email validation logic here
        !email.isEmpty // Placeholder validation
    }
}

struct EmailBubblesView_Previews: PreviewProvider {
    static var previews: some View {
        EmailBubblesView()
    }
}
