//
//  DetailsViewController.swift
//  CurrencyExchange_MVVM
//
//  Created by Dawid Karpiński on 18/04/2022.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {

    //MARK: - Dependencies
    private let viewModel = DetailsViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Outlets
    @IBOutlet weak var codeUIButton: UIButton!
    @IBOutlet weak var outputUISegmentControl: UISegmentedControl!
    @IBOutlet weak var resultUILabel: UILabel!
    @IBOutlet weak var valueUITextField: UITextField!
    @IBOutlet weak var currencyUIPickerView: UIPickerView!
    
    //MARK: - Models
    var rate: RateModel?
    var currencyDataPicker = [(String, String)]()
    
    private let rightUIBarButton = UIBarButtonItem(title: "Ok", style: .done, target: DetailsViewController.self, action: nil)
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadContent()
        bindToViewModel()
    }
    
    private func setup(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func loadContent(){
        
        //Navigation Items
        self.navigationItem.title = rate?.currency
        self.navigationItem.largeTitleDisplayMode = .always
        
        //UISegmentControl
        self.outputUISegmentControl.setTitle(NSLocalizedString("Buy", comment: ""), forSegmentAt: 0)
        self.outputUISegmentControl.setTitle(NSLocalizedString("Sell", comment: ""), forSegmentAt: 1)
        
        //UIButton
        self.codeUIButton.setTitle(rate?.code, for: .normal)
    }
    
    private func cancanelUIPicker() {
        if self.navigationItem.rightBarButtonItems != nil {
            self.navigationItem.setRightBarButton(nil, animated: false)
            currencyUIPickerView.isHidden = true
        }
    }
    
    //MARK: - Bind to ViewModel
    private func bindToViewModel(){
        
        outputUISegmentControl.rx.selectedSegmentIndex
            .map{ $0 == 0 ? self.rate!.ask : self.rate!.bid}
            .bind(to: viewModel.outputTextPublishSubject)
            .disposed(by: disposeBag)
        
        valueUITextField.rx.text
            .map{ ($0?.isEmpty)! ? "0" : $0!}
            .bind(to: viewModel.ammountTextPublishSubject)
            .disposed(by: disposeBag)
                
        viewModel.currentAmmount()
            .bind(to: resultUILabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputTextPublishSubject
            .onNext(self.rate!.bid)
        
        viewModel.dataPicker()
            .bind(to: currencyUIPickerView.rx.itemTitles){ _, element in
            return "\(element.0) - \(element.1)"            
        }.disposed(by: disposeBag)
        
        viewModel.dataPickerPublishSubject
            .onNext(self.currencyDataPicker)
        
            createEvent()
    }
    
    //MARK: - CreateEevent( rightBarButton, codeButton, valueTextField)
    private func createEvent(){
        
        self.rightUIBarButton.rx.tap
            .withLatestFrom(currencyUIPickerView.rx.itemSelected.asObservable()){ _, picker in
            return picker.row
        }.subscribe(onNext:{ [weak self] item in
            self?.changeCurrency(row: item)})
        .disposed(by: disposeBag)
        
        codeUIButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext:{ _ in
            if self.currencyUIPickerView.isHidden {
                if self.valueUITextField.isFirstResponder {
                    self.valueUITextField.resignFirstResponder()
                }
                self.navigationItem.setRightBarButton(self.rightUIBarButton, animated: true)
                self.currencyUIPickerView.isHidden = false
                self.currencyUIPickerView.becomeFirstResponder()
            }
        }).disposed(by: disposeBag)
        
        valueUITextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { _ in
            self.valueUITextField.becomeFirstResponder()
            self.cancanelUIPicker()
        }).disposed(by: disposeBag)
        
    }
    
    //Change current currency
    private func changeCurrency(row: Int) {
        let code = currencyDataPicker[row].0
        viewModel.getSingleCurrency(code: code).share(replay: 1).subscribe(onNext: { singleCurrency in
            DispatchQueue.main.async {
                self.updateView(value: singleCurrency)
            }
        }).disposed(by: disposeBag)
    }
    
    // Update view if change currency
    private func updateView(value: SingleCurrencyModel){
        rate = RateModel(singleCurrency: value)
        loadContent()
            if self.outputUISegmentControl.selectedSegmentIndex == 0 {
                viewModel.outputTextPublishSubject.onNext((self.rate!.ask))
            } else {
                viewModel.outputTextPublishSubject.onNext((self.rate!.bid))
            }
        cancanelUIPicker()
    }
    
}
