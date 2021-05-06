//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 30/04/21.
//

import SwiftUI
import Combine

struct PokemonListView: View {
    
    @ObservedObject private var pokemonListViewModel: PokemonListViewModel
    @State private var tableView: UITableView?
    
    init() {
        self.pokemonListViewModel = PokemonListViewModel()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer()
                    Text("Pokemon Caricati \(self.pokemonListViewModel.pokemons.count)")
                        .font(.caption)
                        .padding(.trailing)
                }
                List(self.pokemonListViewModel.pokemons, id: \.id) { pokemonViewModel in
                    NavigationLink(destination: PokemonDetailView()) {
                        PokemonItem(pokemon: pokemonViewModel)
                            .onAppear {
                                pokemonListViewModel.loadMorePokemonsIfNeeded(currentPokemon: pokemonViewModel)
                            }
                    }
                }
                .navigationBarTitle("Pokedex")
                .alert(isPresented: $pokemonListViewModel.showError, content: {
                    Alert(title: Text("Error"), message: Text(pokemonListViewModel.state.errorDescription ?? PokemonError.genericError.localizedDescription), dismissButton: .default(Text("OK"), action: {
                        pokemonListViewModel.showError = false
                    }))
                })
                
                if self.pokemonListViewModel.state.isLoading {
                    Text("Loading...")
                }
            }
        }
        
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
