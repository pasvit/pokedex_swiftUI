//
//  String+extensions.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
