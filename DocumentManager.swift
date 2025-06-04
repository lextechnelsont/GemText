import SwiftUI

class DocumentManager: ObservableObject {
    @Published var document: EditableDocument?

    func openDocument(at url: URL) {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            self.document = EditableDocument(url: url, content: content)
        } catch {
            print("Failed to open file: \(error)")
        }
    }
}

struct EditableDocument {
    let url: URL
    var content: String
}