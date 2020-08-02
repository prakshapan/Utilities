import SwiftUI

class FieldElement: ObservableObject, Identifiable {
    var id = UUID()
    var title = ""
    @Published var value = ""
    var keyboard: UIKeyboardType = .asciiCapable
    var returnType: UIReturnKeyType = .next

    init(title: String, value: String = "", keyboard: UIKeyboardType = .asciiCapable, returnType: UIReturnKeyType = .next) {
        self.title = title
        self.value = value
        self.keyboard = keyboard
        self.returnType = returnType
    }
}

struct FormView: View {
    @State var formElements: [FieldElement] = [
        FieldElement(title: "Name"),
        FieldElement(title: "Address"),
        FieldElement(title: "Phone Number"),
        FieldElement(title: "Email Address", keyboard: .emailAddress, returnType: .done),
    ]

    @State var selectedField = 0


    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(zip(formElements.indices, formElements)), id: \.0) { index, element in
                VStack(alignment: .leading, spacing: 0) {
                    Text(element.title)

                    NextLineTextField(text: self.$formElements[index].value,
                        selectedField: self.$selectedField,
                        tag: index,
                        keyboardType: element.keyboard,
                        returnKey: element.returnType)
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 0.7)
                        )
                }.padding(.bottom, 4)
            }

            Button(action: {
                print(self.formElements.map({ $0.value }))
            }) {
                Text("Print Entered Values")
                    .foregroundColor(Color.white)
                    .font(.body)
                    .padding()
            }.frame(height: 50)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.vertical, 10)
            Spacer()
        }.padding()
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}


struct NextLineTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var selectedField: Int

    var tag: Int
    var keyboardType: UIKeyboardType = .asciiCapable
    var returnKey: UIReturnKeyType = .next

    func makeUIView(context: UIViewRepresentableContext<NextLineTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKey
        textField.tag = tag
        return textField
    }

    func makeCoordinator() -> NextLineTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NextLineTextField>) {
        uiView.text = text
        context.coordinator.newSelection = { newSelection in
            DispatchQueue.main.async {
                self.selectedField = newSelection
            }
        }
        
        if uiView.tag == self.selectedField {
            uiView.becomeFirstResponder()
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var newSelection: (Int) -> () = { _ in }

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.newSelection(textField.tag)
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField.returnKeyType == .done {
                textField.resignFirstResponder()
            } else {
                self.newSelection(textField.tag + 1)
            }
            return true
        }
    }
}
