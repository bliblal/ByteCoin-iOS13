//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrencyValues(_ parseddata: CurrencyModel)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "46352A93-7F04-485F-9DB1-E70E6DD792C0"    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","JPY","MXN","NOK","NZD","PKR","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var selectedCurrency = "AUD"
    
    
    let defaultrates = CurrencyModel(filteredRates: [
        Rate(assetIDQuote: "AUD", rate: 0.0),
        Rate(assetIDQuote: "BRL", rate: 0.0),
        Rate(assetIDQuote: "CAD", rate: 0.0),
        Rate(assetIDQuote: "CNY", rate: 0.0),
        Rate(assetIDQuote: "EUR", rate: 0.0),
        Rate(assetIDQuote: "GBP", rate: 0.0),
        Rate(assetIDQuote: "HKD", rate: 0.0),
        Rate(assetIDQuote: "IDR", rate: 0.0),
        Rate(assetIDQuote: "ILS", rate: 0.0),
        Rate(assetIDQuote: "JPY", rate: 0.0),
        Rate(assetIDQuote: "MXN", rate: 0.0),
        Rate(assetIDQuote: "NOK", rate: 0.0),
        Rate(assetIDQuote: "NZD", rate: 0.0),
        Rate(assetIDQuote: "PKR", rate: 0.0),
        Rate(assetIDQuote: "PLN", rate: 0.0),
        Rate(assetIDQuote: "RON", rate: 0.0),
        Rate(assetIDQuote: "RUB", rate: 0.0),
        Rate(assetIDQuote: "SEK", rate: 0.0),
        Rate(assetIDQuote: "SGD", rate: 0.0),
        Rate(assetIDQuote: "USD", rate: 0.0),
        Rate(assetIDQuote: "ZAR", rate: 0.0)
    ])
    
    func fetchCurrencyData(){
        let finalURL = "\(baseURL)/APIKEY-\(apiKey)"
        print(finalURL)
        performCall(finalURL)
    }
    
    func performCall(_ finalURL: String){
        if let url = URL(string: finalURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                
                if let safedata = data {
                    let parsedData = parseJSON(safedata)
                    delegate?.didUpdateCurrencyValues(parsedData ?? defaultrates)
                }
            }
            task.resume()
            
            
        }
    }
    
    
    func parseJSON(_ safedata: Data) -> CurrencyModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: safedata)
            // Filter the rates array based on the allowedAssetIds
            let filteredRates = decodedData.rates.filter { currencyArray.contains($0.assetIDQuote) }
            
            // Create a new CoinData structure with the filtered rates
            let filteredCurrencyData = CurrencyModel(filteredRates: filteredRates)
            return filteredCurrencyData
        }
        catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }

    
}

