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
}

struct AppEnvironment {
    
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
	todoReducer.forEach(state: \AppState.todos, action: /AppAction.todo(index:action:), environment: { _ in TodoEnvironment() })

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
					ForEachStore(self.store.scope(state: { $0.todos },
												  action: { AppAction.todo(index: $0, action: $1) })) { todoStore in
						TodoView(store: todoStore)
					}
                }
				.navigationBarTitle("Todos")
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
				
				TextField("Untitled todo", text: todoViewStore.binding(
					get: { $0.description },
					send: { .textFieldChanged($0) }
				))
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
