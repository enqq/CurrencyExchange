//
//  DetailsViewModel.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 02/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

class DetailsViewModel {
    let ammountTextPublishSubject = PublishSubject<String>()
    let outputTextPublishSubject = PublishSubject<Float>()
    let dataPickerPublishSubject = PublishSubject<[(String, String)]>()
    
    private let apiService = ApiServices()
    
    func currentAmmount() -> Observable<String>{
        return Observable.combineLatest(ammountTextPublishSubject.asObservable(), outputTextPublishSubject.asObservable()){ ammount, output in
            print("Ammount \(ammount) output \(output)")
            let result =  Float(ammount)! * output
            return self.ammountFormatter(result: result)!
        }.startWith("0")
    }
    
    private func ammountFormatter(result: Float) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        return formatter.string(from: NSNumber.init(value: result))
    }
    
     func dataPicker() -> Observable<[(String, String)]> {
         return dataPickerPublishSubject.asObservable()
    }
    
    func getSingleCurrency(code: String) -> Observable<SingleCurrencyModel> {
        return apiService.getData(urlAdress: "rates/c/\(code)/?format=json")
    }
}
