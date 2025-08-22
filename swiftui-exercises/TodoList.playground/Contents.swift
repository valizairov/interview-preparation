import SwiftUI
import PlaygroundSupport

struct TodoItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    var done: Bool = false
}

struct TodoListView: View {
    @State private var todos: [TodoItem] = UserDefaults.standard.loadTodos()
    @State private var newTodo: String = ""
    @State private var filter: Filter = .all
    
    enum Filter { case all, completed, pending }
    
    var filteredTodos: [TodoItem] {
        switch filter {
        case .all: return todos
        case .completed: return todos.filter { $0.done }
        case .pending: return todos.filter{ !$0.done}
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("New task", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTodo) {
                        Text("Add")
                    }
                }
                .padding()
                
                HStack {
                    Button("All") { filter = .all }
                    Button("Completed") { filter = .completed }
                    Button("Pending") { filter = .pending }
                }
                
                List {
                    ForEach(filteredTodos) { todo in
                        HStack {
                            Button(action: { toggle(todo) }) {
                                Image(systemName: todo.done ? "checkmark.square" : "square")
                            }
                            Text(todo.title)
                                .strikethrough(todo.done)
                        }
                        .animation(.default, value: todos)
                    }
                    .onDelete(perform: deleteTodo)
                }
            }
            .padding()
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
    
    func toggle(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: {$0.id == todo.id }) {
            todos[index].done.toggle()
            UserDefaults.standard.saveTodos(todos)
        }
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

