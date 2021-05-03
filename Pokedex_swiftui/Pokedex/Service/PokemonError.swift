//
//  PokemonError.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 30/04/21.
//

enum PokemonError: Error {
    case statusCode
    case decoding
    case invalidURL
    case genericError
    case other(Error)
    
    var localizedDescription: String {
        switch self {
        case .statusCode:
            return "Status Code Error"
        case .decoding:
            return "Decoding Error"
        case .invalidURL:
            return "Invalid URL Error"
        case .genericError:
            return "Generic Error"
        case .other(let error):
            return error.localizedDescription
        default:
            return PokemonError.genericError.localizedDescription
        }
    }
    
    static func map(_ error: Error) -> PokemonError {
        return (error as? PokemonError) ?? .other(error)
    }
}
