//
//  PokemonService.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 30/04/21.
//

import Foundation
import Combine
import SwiftUI

class PokemonService {
    
    let baseUrl: String = "https://pokeapi.co/api/v2/pokemon"
    let mediaUrl: String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    
    func fetchPokemons(urlString: String?) -> AnyPublisher<Pokedex, PokemonError> {
        guard let url = URL(string: urlString ?? baseUrl) else {
            return Fail(error: PokemonError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw PokemonError.statusCode
                }
                
                return response.data
            }
            .decode(type: Pokedex.self, decoder: JSONDecoder())
            .mapError { PokemonError.map($0) }
            .receive(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonImage(with id: Int) -> AnyPublisher<Image, PokemonError> {
        let stringUrl = mediaUrl + "/\(String(id)).png"
        
        guard let url = URL(string: stringUrl) else {
            return Fail(error: PokemonError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw PokemonError.statusCode
                }
                
                return response.data
            }
            .tryMap({ data in
                return Image(uiImage: UIImage(data: data) ?? UIImage())
            })
            .mapError { PokemonError.map($0) }
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }
    
}
