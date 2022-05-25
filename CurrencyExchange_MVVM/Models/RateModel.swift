//
//  CurrenciesModel.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 18/04/2022.
//

import Foundation
class RateModel : Decodable {
    let currency: String
    let code: String
    let bid: Float
    let ask: Float
    

    init(singleCurrency: SingleCurrencyModel){
        self.currency = singleCurrency.currency
        self.code = singleCurrency.code
        self.ask = singleCurrency.rates[0].ask
        self.bid = singleCurrency.rates[0].bid
    }
}
