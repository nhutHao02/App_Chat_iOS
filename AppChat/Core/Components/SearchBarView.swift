//
//  SearchBarView.swift
//  AppChat
//
//  Created by TranHao on 28/02/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var body: some View {
        HStack{
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(.gray.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                )
        }
        
        .padding(8)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(" "))
    }
}
