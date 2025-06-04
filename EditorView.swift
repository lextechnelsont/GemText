import SwiftUI

struct EditorView: View {
    @State var document: EditableDocument
    @State private var isEditing = false
    @State private var showFind = false
    @State private var showToast = false

    var body: some View {
        VStack {
            toolbar
            Divider()
            content
        }
        .toast(isPresented: $showToast, message: "\(document.url.lastPathComponent) saved")
        .sheet(isPresented: $showFind) {
            FindReplaceView(document: $document)
        }
    }

    private var toolbar: some View {
        HStack {
            Toggle("EDIT", isOn: $isEditing)
                .toggleStyle(.button)
                .onChange(of: isEditing) { newValue in
                    if !newValue {
                        saveDocument()
                    }
                }
            Spacer()
            Button(action: { showFind = true }) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }

    @ViewBuilder
    private var content: some View {
        if isEditing {
            TextEditor(text: $document.content)
                .padding()
        } else {
            ScrollView {
                if let attributed = try? AttributedString(markdown: document.content) {
                    Text(attributed)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                } else {
                    Text(document.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
        }
    }

    private func saveDocument() {
        do {
            try document.content.write(to: document.url, atomically: true, encoding: .utf8)
            showToast = true
        } catch {
            print("Failed to save: \(error)")
        }
    }
}