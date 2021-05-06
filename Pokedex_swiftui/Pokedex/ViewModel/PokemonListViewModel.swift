//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 30/04/21.
//

import SwiftUI
import Combine
import Foundation

enum PokemonListViewModelState {
    case notLoad
    case loading
    case finishedLoading
    case error(PokemonError)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var errorDescription: String? {
        if case .error(let error) = self { return error.localizedDescription }
        return nil
    }
}

class PokemonListViewModel: ObservableObject {
    
    @Published var pokemons = [PokemonViewModel]()
    @Published var state: PokemonListViewModelState = .notLoad
    @Published var showError: Bool = false
    
    private var pokedex: Pokedex?
    private var currentPage = 1
    private var canLoadMorePages = true // to do
    private var cancellable: AnyCancellable?
    
    private var pokemonCounter: Int = 0
    
    init() {
        loadMorePokemons()
    }
    
    func loadMorePokemonsIfNeeded(currentPokemon pokemon: PokemonViewModel?) {
        guard let pokemon = pokemon else {
            loadMorePokemons()
            return
        }
        
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -1)
        if pokemons.firstIndex(where: { $0.id == pokemon.id }) == thresholdIndex {
            loadMorePokemons()
        }
    }
    
    private func loadMorePokemons() {
        guard !state.isLoading && canLoadMorePages else {
            return
        }
        
        state = .loading
        
        let loadPokemonsCompletionHandler: (Subscribers.Completion<PokemonError>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
                self?.showError = true
            case .finished: self?.state = .finishedLoading
            }
        }
        
        
        let urlString = pokedex?.next
        
        self.cancellable = PokemonService().fetchPokemons(urlString: urlString)
            .receive(on: RunLoop.main)
            .map{ pokedex in
                self.pokedex = pokedex
                var pokemons: [PokemonViewModel] = []
                
                for (_, pokemon) in pokedex.results.enumerated() {
                    self.pokemonCounter += 1
                    pokemons.append(PokemonViewModel(id: self.pokemonCounter, pokemon: pokemon))
                }
                return pokemons
            }.sink(receiveCompletion: loadPokemonsCompletionHandler, receiveValue: { pokemonsViewModels in
                self.pokemons += pokemonsViewModels
            })
        
    }
    
}

class PokemonViewModel: ObservableObject, Identifiable {
    
    private var cancellable: AnyCancellable?
    
    let id: Int
    let pokemon: Pokemon
        
    var name: String {
        return self.pokemon.name
    }
    
    @Published var image: Image?
    
    init(id: Int, pokemon: Pokemon) {
        self.id = id
        self.pokemon = pokemon
        self.image = nil
        fetchPokemonImage()
    }
    
    func fetchPokemonImage() {
        self.cancellable = PokemonService().fetchPokemonImage(with: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion:{_ in }, receiveValue: { image in
                self.image = image
            })
    }
}
