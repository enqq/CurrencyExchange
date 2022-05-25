//
//  MainViewModel.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 18/04/2022.
//

import Foundation
import RxSwift
class MainViewModel {
    private var apiServices = ApiServices()
    
    func getCurrency() -> Observable<[CurrencyModel]> {
        return apiServices.getData(urlAdress: "tables/C/%20?format=json")
    }
}
