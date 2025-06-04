import SwiftUI

struct ContentView: View {
    @StateObject private var documentManager = DocumentManager()

    var body: some View {
        Group {
            if let document = documentManager.document {
                EditorView(document: document)
            } else {
                FilePickerView { url in
                    documentManager.openDocument(at: url)
                }
            }
        }
    }
}