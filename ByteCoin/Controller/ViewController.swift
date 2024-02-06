//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Variables
    var coinmanager = CoinManager()
    
    
    //MARK: - Outlets
    @IBOutlet weak var bitcoinAmount: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        
    }
    
    
    //MARK: - Private methods
    func updateLabelWithSelectedCurrency() {
        currencyLabel.text = coinmanager.selectedCurrency
    }
}

//MARK: -PICKERVIEW
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinmanager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinmanager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinmanager.selectedCurrency = coinmanager.currencyArray[row]
        updateLabelWithSelectedCurrency()
        coinmanager.fetchCurrencyData()
    }
    
    func setupView(){
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinmanager.delegate = self
        updateLabelWithSelectedCurrency()
        coinmanager.fetchCurrencyData()
    }
}


//MARK: - CoinManager Delegate
extension ViewController: CoinManagerDelegate {
    func didUpdateCurrencyValues(_ parseddata: CurrencyModel) {
        DispatchQueue.main.async{
            print(parseddata)
            let currency = parseddata.filteredRates.filter { self.coinmanager.selectedCurrency == $0.assetIDQuote }
            self.currencyAmountLabel.text = String(format: "%.1f", currency[0].rate)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}


