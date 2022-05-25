//
//  ApiServices.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 18/04/2022.
//

import Foundation
import RxSwift
class ApiServices{
    
    private let baseUrl = "https://api.nbp.pl/api/exchangerates/"
    
    func getData<T: Decodable>(urlAdress url: String) -> Observable<T>{
        return Observable<T>.create(){ subscribe in
            var currentUrl = self.baseUrl
            currentUrl += url
            let task = URLSession.shared.dataTask(with: URL.init(string: currentUrl)!){ data, _, _ in
                guard let data = data, let json = try? JSONDecoder().decode(T.self, from: data) else {
                    print("error \(currentUrl)")
                    return
                }
                subscribe.onNext(json)
                subscribe.onCompleted()
            }
            task.resume();
            return Disposables.create{
                task.cancel()
            }
        }
    }
}
