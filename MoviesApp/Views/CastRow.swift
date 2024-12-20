//
//  CastRow.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI

// MARK: - CastRow
struct CastRow: View {
    let cast: CastMember

    var body: some View {
        HStack {
            // Cast Name and Role
            VStack(alignment: .leading) {
                Text(cast.name!)
                    .font(.headline)
                Text(cast.department!)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Popularity Score
            Text("Popularity: \(Int(cast.popularity))")
                .font(.footnote)
        }
        .padding(.vertical, 5)
    }
}
