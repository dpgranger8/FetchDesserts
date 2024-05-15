//
//  UnavailableView.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import SwiftUI

struct UnavailableView: View {
    var message: String
    var action: () -> ()
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("Network Error", systemImage: "network.slash")
        }, description: {
            Text(message)
        }, actions: {
            Button {
                action()
            } label: {
                Label("Retry", systemImage: "arrow.circlepath")
            }
        })
    }
}
