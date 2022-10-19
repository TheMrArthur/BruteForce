//
//  ExtensionString.swift
//  BruteForce
//
//  Created by Arthur on 17.10.2022.
//

import Foundation

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character)) ?? 0
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index]): Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var result = string
    
    if result.count <= 0 {
        result.append(characterAt(index: 0, array))
    }
    else {
        result.replace(at: result.count - 1,
                       with: characterAt(index: (indexOf(character: result.last ?? "-", array) + 1) % array.count, array))
        
        if indexOf(character: result.last ?? "-", array) == 0 {
            result = String(generateBruteForce(String(result.dropLast()), fromArray: array)) + String(result.last ?? "-")
        }
    }
    return result
}
