//
//  CryptoCurrency.swift
//  CryptoCurrency App
//
//  Created by SWIFT on 18.04.2025.
//

import Foundation

struct CryptoCurrency: Codable {
    
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int
    let high24H: Double
    let low24H: Double
    let aTHPrice: Double
    let aTHDate: Date?
    let aTLPrice: Double
    let aTLDate: Date?
    let percentFromATL: Double
    let athChangePercentage: Double

        enum CodingKeys: String, CodingKey {
            case name
            case image
            case currentPrice = "current_price"
            case marketCap = "market_cap"
            case marketCapRank = "market_cap_rank"
            case high24H = "high_24h"
            case low24H = "low_24h"
            case aTHPrice = "ath"
            case aTHDate = "ath_date"
            case aTLPrice = "atl"
            case aTLDate = "atl_date"
            case percentFromATL = "atl_change_percentage"
            case athChangePercentage = "ath_change_percentage"
            
        }
    }

