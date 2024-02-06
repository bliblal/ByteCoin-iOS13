//
//  CoinData.swift
//  ByteCoin
//
//  Created by Bilal Javed on 02/02/2024.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let assetIDBase: String
    let rates: [Rate]
    
    enum CodingKeys: String, CodingKey {
        case assetIDBase = "asset_id_base"
        case rates
    }
}

// MARK: - Rate
struct Rate: Codable {
    let assetIDQuote: String
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case assetIDQuote = "asset_id_quote"
        case rate
    }
}

