//
//  CurrencyModel.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 18/04/2022.
//

import Foundation
class CurrencyModel : Decodable {
    let table: String
    let no: String
    let tradingDate: String
    let effectiveDate: String
    var rates: [RateModel]
}
