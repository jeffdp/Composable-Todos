//
//  ContentView.swift
//  Todos
//
//  Created by Jeff Porter on 5/30/20.
//  Copyright © 2020 Jeff Porter. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct Todo: Equatable, Identifiable {
    let id: UUID
    var description = ""
    var isComplete = false
}

enum TodoAction {
	case checkboxTapped
	case textFieldChanged(String)
}

struct TodoEnvironment {
	
}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { state, action, environment in
	switch action {
	case .checkboxTapped:
        state.isComplete.toggle()
        return .none
		
	case .textFieldChanged(let text):
        state.description = text
		return .none
	}
}
.debug()

struct AppState: Equatable {
    var todos: [Todo]
}

enum AppAction {
	case todo(index: Int, action: TodoAction)
	case addButtonTapped
}

struct AppEnvironment {
    
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
	todoReducer.forEach(state: \AppState.todos, action: /AppAction.todo(index:action:), environment: { _ in TodoEnvironment() }),
	Reducer { state, action, Environment in
		switch action {
		case .todo(index: let index, action: let action):
			return .none
		case .addButtonTapped:
			state.todos.insert(Todo(id: UUID()), at: 0)
			return .none
		}
	}
)
	

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
					ForEachStore(self.store.scope(state: \.todos, action: AppAction.todo(index:action:)),
								 content: TodoView.init(store:))
                }
				.navigationBarTitle("Todos")
				.navigationBarItems(trailing: Button("Add") {
					viewStore.send(.addButtonTapped)
				})
            }
        }
    }
}

struct TodoView: View {
	let store: Store<Todo, TodoAction>
	
	var body: some View {
		WithViewStore(store) { todoViewStore in
			HStack {
				Button(action: { todoViewStore.send(.checkboxTapped) }) {
					Image(systemName: todoViewStore.isComplete ? "checkmark.square" : "square")
				}
				.buttonStyle(PlainButtonStyle())
				
				TextField("Untitled todo",
						  text: todoViewStore.binding(get: \.description, send: TodoAction.textFieldChanged))
			}
			.foregroundColor(todoViewStore.isComplete ? .gray : nil)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static let mockTodos = [
        Todo(id: UUID(),
             description: "Whiskey",
                 isComplete: false),
        Todo(id: UUID(),
             description: "Bourbon",
             isComplete: false),
        Todo(id: UUID(),
             description: "Beer",
             isComplete: true),
    ]
    
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(todos: mockTodos),
                                 reducer: appReducer,
                                 environment: AppEnvironment()))
    }
}
