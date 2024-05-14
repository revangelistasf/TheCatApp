//
//  MainView.swift
//  TheCatApp
//
//  Created by revangelista on 04/05/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            BreedListView(
                viewModel: BreedListViewModel(
                    repository: BreedRepository()
                )
            )
            .tabItem {
                Label("Breed List", systemImage: "cat")
            }

            FavoritesView(
                viewModel: FavoritesViewModel(repository: BreedRepository())
            )
            .tabItem {
                Label("Favorites", systemImage: "star")
            }
        }
    }
}

#Preview {
    MainView()
}
