import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.title) private var books: [Book]
    @State var createNewBook = false
    var body: some View {
        NavigationStack {
            Group {
            if books.isEmpty {
                VStack {
                    Image(systemName: "book.fill")
                        .font(.largeTitle)
                        .padding(.bottom, 2)
                    Text("Enter your first book")
                        .bold()
                        .font(.title2)
                }
                
            } else {
                List{
                    ForEach(books) { book in
                        NavigationLink {
                            EditBookView(book: book)
                        } label: {
                            HStack(spacing: 10) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.title2)
                                    Text(book.author).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            context.delete(book)
                        }
                    })
                }
                .listStyle(.plain)
        }
    }
            .navigationTitle("My Books")
            .toolbar{
                Button{
                    createNewBook.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
                .fullScreenCover(isPresented: $createNewBook, content: {
                    NewBookView()
                })
            }
        }
    }
}

#Preview {
    BookListView()
        .modelContainer(for: Book.self , inMemory: true)
}
