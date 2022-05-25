//
//  ViewController.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 18/04/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    //MARK: - Dependencies
    private let mainViewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Models
    private var currencyList = [(String, String)]()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bindTabelView()
    }
    
    //MARK: - Bint To TableView, Create event, RegisterCell
    private func bindTabelView() {

        mainViewModel.getCurrency().share().map{
            return $0[0].rates
        }.do(onNext:{
            self.currencyList = $0.map({ ($0.code, $0.currency) })
        }).bind(to: tableView.rx.items(cellIdentifier: "rateCell", cellType: RateTableViewCell.self)){ (index, currencies, cell) in
            cell.rateName.text = currencies.currency
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RateModel.self).subscribe(onNext: { [weak self] item in
            self?.tapRowTableView(rate: item)
        }).disposed(by: disposeBag)
    }
    
    private func registerCell() {
        self.tableView.register(UINib(nibName: "RateTableViewCell", bundle: nil), forCellReuseIdentifier: "rateCell")
    }


    private func tapRowTableView(rate: RateModel){
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboardMain.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.rate = rate
        detailsVC.currencyDataPicker = self.currencyList
        self.show(detailsVC, sender: nil)
    }
}

