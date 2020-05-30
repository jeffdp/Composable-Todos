//
//  ContentView.swift
//  Todos
//
//  Created by Jeff Porter on 5/30/20.
//  Copyright © 2020 Jeff Porter. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppState {
    
}

enum AppAction {
    
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
            List {
                Text("Hello")
            }
        .navigationBarTitle("Todos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(),
                                 reducer: appReducer,
                                 environment: AppEnvironment()))
    }
}
