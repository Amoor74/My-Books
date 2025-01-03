import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    @State private var title = " "
    @State private var author = " "
    @State private var summary = " "
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var status = Status.onShelf
    @State private var firstView = true
    
    var body: some View {
        HStack{
            Text("Status:")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.description).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading){
            GroupBox {
                LabeledContent{
                    DatePicker(" ", selection: $dateAdded , displayedComponents: .date)
                } label: {
                    Text(" Date Added")
                }
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded... , displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                if status == .onShelf {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted... , displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !firstView {
                    if newValue == .onShelf {
                        dateStarted = .distantPast
                        dateCompleted = .distantPast
                    } else if newValue == .inProgress && oldValue == .completed {
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        dateStarted = .now
                    } else if newValue == .completed && oldValue == .onShelf {
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    }  else {
                        dateCompleted = Date.now
                    }
                    firstView = false
                }
            }
            Divider()
            LabeledContent {
                TextField("", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            Divider()
            Text("Summary").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill)))
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            if changed {
                Button("Update") {
                    book.status = status
                    book.author = author
                    book.title = title
                    book.dateStarted = dateStarted
                    book.dateAdded = dateAdded
                    book.dateCompleted = dateCompleted
                    book.summary = summary
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status = book.status
            title = book.title
            author = book.author
            summary = book.summary
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
        }
    }
    var changed: Bool {
        status != book.status
        || title != book.title
        || author != book.author
        || summary != book.summary
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
    }
}

#Preview {
    BookListView()
}
