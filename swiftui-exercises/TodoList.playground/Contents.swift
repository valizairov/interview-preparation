import SwiftUI
import PlaygroundSupport

struct TodoItem: Identifiable, Codable {
    let id = UUID()
    let title: String
}

struct TodoListView: View {
    @State private var todos: [TodoItem] = UserDefaults.standard.loadTodos()
    @State private var newTodo: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New task", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTodo) {
                        Text("Add")
                    }
                }
                .padding()
                
                List {
                    ForEach(todos) { todo in
                        Text(todo.title)
                    }
                    .onDelete(perform: deleteTodo)
                }
            }
            .navigationTitle("To Do List")
        }
    }
    
    func addTodo() {
        guard !newTodo.isEmpty else { return }
        let item = TodoItem(title: newTodo)
        todos.append(item)
        newTodo = ""
        UserDefaults.standard.saveTodos(todos)
    }
    
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        UserDefaults.standard.saveTodos(todos)
    }
}

extension UserDefaults {
    private static let key = "todosKey"
    
    func loadTodos() -> [TodoItem] {
        if let data = data(forKey: Self.key),
        let items = try? JSONDecoder().decode([TodoItem].self, from: data) {
            return items
        }
        return []
    }
    
    func saveTodos(_ todos: [TodoItem]) {
        if let data = try? JSONEncoder().encode(todos) {
            set(data, forKey: Self.key)
        }
    }
}

PlaygroundPage.current.setLiveView(TodoListView())

