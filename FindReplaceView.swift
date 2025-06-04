import SwiftUI

struct FindReplaceView: View {
    @Binding var document: EditableDocument
    @State private var searchText = ""
    @State private var replaceText = ""
    @State private var useRegex = false
    @State private var matchCount = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Find")) {
                    TextField("Search", text: $searchText)
                    Toggle("Use Regular Expression", isOn: $useRegex)
                }
                Section(header: Text("Replace")) {
                    TextField("Replace with", text: $replaceText)
                    Button("Replace All", action: replaceAll)
                }
                Section {
                    Text("Matches Found: \(matchCount)")
                }
            }
            .navigationTitle("Find & Replace")
            .onChange(of: searchText) { _ in countMatches() }
            .onChange(of: useRegex) { _ in countMatches() }
        }
    }

    private func countMatches() {
        guard !searchText.isEmpty else {
            matchCount = 0
            return
        }

        do {
            let regex = try NSRegularExpression(
                pattern: useRegex ? searchText : NSRegularExpression.escapedPattern(for: searchText),
                options: []
            )
            let range = NSRange(document.content.startIndex..., in: document.content)
            matchCount = regex.numberOfMatches(in: document.content, options: [], range: range)
        } catch {
            matchCount = 0
        }
    }

    private func replaceAll() {
        do {
            let regex = try NSRegularExpression(
                pattern: useRegex ? searchText : NSRegularExpression.escapedPattern(for: searchText),
                options: []
            )
            let range = NSRange(document.content.startIndex..., in: document.content)
            document.content = regex.stringByReplacingMatches(in: document.content, options: [], range: range, withTemplate: replaceText)
            countMatches()
        } catch {
            print("Regex error: \(error)")
        }
    }
}