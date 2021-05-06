//
//  PokemonItem.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import SwiftUI

struct PokemonItem: View {
    @ObservedObject var pokemon: PokemonViewModel
    
    var body: some View {
        ZStack {
            
            // MARK: - Pokemon Detail
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(pokemon.name.capitalizingFirstLetter())
                        .font(.custom("CircularStd-Bold", size: 14))
                        .foregroundColor(.black)
                    
                    
                }
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.vertical, 25)
            
            // MARK: - Pokemon Background
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("pokeball_background")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                }
            }.padding(.top, 25)
            
            // MARK: - Pokemon Image
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    pokemon.image?
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .offset(x: 0, y: -40)
                }
            }
            
        }
        .frame(height: 110)
        .shadow(radius: 5)
        .background(Color.primaryColor)
        .cornerRadius(10)
    }
}

struct PokemonCard_Previews: PreviewProvider {
    static var previews: some View {
        PokemonItem(pokemon: PokemonViewModel(id: 1, pokemon: Pokemon(name: "bulbasaur")))
            .previewLayout(.sizeThatFits)
            .frame(width: 180)
            .padding(.all)
    }
}
