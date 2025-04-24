//
//  FavoritesManager.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 21.04.2025.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    
    private init() {}
    
    private(set) var favorites: [CryptoCurrency] = []
    
    func isFavorite(_ crypto: CryptoCurrency) -> Bool {
        return favorites.contains(where: { $0.name == crypto.name })
    }
    
    func toggleFavorite(_ crypto: CryptoCurrency) -> Bool {
        if let index = favorites.firstIndex(where: { $0.name == crypto.name }) {
            favorites.remove(at: index)
            return false
        } else {
            favorites.append(crypto)
            return true
        }
    }
}
