//
//  SingleCurrencyModel.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 09/05/2022.
//

import Foundation
struct SingleCurrencyModel: Decodable {
    let table: String
    let currency: String
    let code: String
    let rates: [SingleRateModel]
}
struct SingleRateModel: Decodable {
    let no: String
    let effectiveDate: String
    let bid: Float
    let ask: Float
}
