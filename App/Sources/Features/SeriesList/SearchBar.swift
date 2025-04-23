//
//  SearchBar.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search by name...", text: $text)
            .padding(10)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.top)
            .submitLabel(.search)
    }
}
