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

struct AppState: Equatable {
    var todos: [Todo]
}

enum AppAction: Equatable {
    
}

struct AppEnvironment {
    
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
        
    }
}

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    ForEach(viewStore.todos) { todo in
                        Text(todo.description)
                    }
                }
            .navigationBarTitle("Todos")
            }
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
             isComplete: false),
    ]
    
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(todos: mockTodos),
                                 reducer: appReducer,
                                 environment: AppEnvironment()))
    }
}
