//
//  SearchBar.swift
//  FetchDesserts
//
//  Created by David Granger on 5/16/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @FocusState var isFocused: Bool
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ZStack(alignment: .leading) {
                    if !isFocused && text.isEmpty {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .padding(.leading, 14)
                    }
                    ZStack(alignment: .trailing) {
                        TextField(isFocused ? "Search" : "       Search", text: $text)
                            .accessibilityAddTraits(.isSearchField)
                            .focused($isFocused)
                            .foregroundColor(.primary)
                            .textFieldStyle(OvalTextFieldStyle())
                            .limitInputLength(value: $text, length: 30)
                        
                        if !text.isEmpty {
                            Button {
                                withAnimation {
                                    text = ""
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .accessibilityLabel("Clear text")
                                    .imageScale(.large)
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                            }
                            .padding(.trailing, 7)
                        }
                    }
                }
                if showCancelButton {
                    Button {
                        isFocused = false
                    } label: {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.45)
                            .frame(width: 45, height: 35)
                            .offset(x: 4)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .onChange(of: isFocused) { oldFocused, isFocused in
            showCancelButton = isFocused
        }
        .background(.regularMaterial)
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    @FocusState private var textFieldFocused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Statics.specialGray)
            .cornerRadius(20)
            .focused($textFieldFocused)
            .onTapGesture {
                textFieldFocused = true
            }
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
