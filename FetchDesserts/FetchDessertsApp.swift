//
//  FetchDessertsApp.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI

@main
struct FetchDessertsApp: App {
    @StateObject var vm = HomeScreenVM()
    
    var body: some Scene {
        WindowGroup {
            Home(vm: vm)
                .environment(Network())
        }
    }
}
