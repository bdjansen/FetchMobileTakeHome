//
//  RecipeCellView.swift
//  Recipes
//
//  Created by Blake Jansen on 3/13/25.
//

import SwiftUI

// Display for a single recipe.
struct RecipeCellView: View {
    @StateObject var viewModel: RecipeCellViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Group {
                switch viewModel.state {
                case .initial:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let uIImage):
                    Image(uiImage: uIImage)
                        .resizable()
                case .error:
                    Image(systemName: "carrot")
                        .resizable()
                }
            }
            .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(viewModel.recipe.name)
                    .font(.headline)
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 2)
        )
        .task {
            await viewModel.load()
        }
    }
}
