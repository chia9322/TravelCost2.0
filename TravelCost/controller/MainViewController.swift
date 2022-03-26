//
//  ViewController.swift
//  TravelCost
//
//  Created by Chia on 2021/11/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var carImageView: UIImageView!
    
    @IBOutlet var gasolinePriceTextField: UITextField!
    @IBOutlet var fuelEfficiencyTextField: UITextField!
    @IBOutlet var distanceTextField: UITextField!
    @IBOutlet var tollFeeTextField: UITextField!
    
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var pricePerPersonLabel: UILabel!
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var calculateButton: UIButton!
    
    var numberOfPeople: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGasolinePrice()
        
        let deviceHeight = UIScreen.main.bounds.height
        if deviceHeight < 500 {
            carImageView.isHidden = true
        }
        
        // Picker view
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Text Field
        addTapRecognizer()
        addTextFieldToolbar()
        gasolinePriceTextField.delegate = self
        fuelEfficiencyTextField.delegate = self
        distanceTextField.delegate = self
        tollFeeTextField.delegate = self
        
        gasolinePriceTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingDidEnd)
        fuelEfficiencyTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingDidEnd)
        
        getUserDefaultValues()
        gasolinePriceTextField.text = String(format: "%.1f", gasolinePrice)
        fuelEfficiencyTextField.text = String(format: "%.1f", fuelEfficiency)
        
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        switch textField {
        case gasolinePriceTextField:
            if let value = Double(textField.text!) {
                gasolinePrice = value
                updateGasolinePriceInUserDefault()
            }
        case fuelEfficiencyTextField:
            if let value = Double(textField.text!) {
                fuelEfficiency = value
                updateFuelEfficiencyInUserDefault()
            }
        default:
            break
        }
    }
    
    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(MainViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView() {
        self.view.endEditing(true)
    }
    
    @IBAction func calculate(_ sender: Any) {
        numberOfPeople = pickerView.selectedRow(inComponent: 0) + 1
        
        guard let gasolinePrice = Double(gasolinePriceTextField.text!) else {
            showAlert("ガソリン価格")
            return
        }
        
        guard let fuelEfficiency = Double(fuelEfficiencyTextField.text!) else {
            showAlert("燃費")
            return
        }
        
        if Double(distanceTextField.text!) == nil {
            distanceTextField.text = "0"
        }
        if Double(tollFeeTextField.text!) == nil {
            tollFeeTextField.text = "0"
        }
        
        if let distance = Double(distanceTextField.text!),
           let tollFee = Double(tollFeeTextField.text!) {
            // 計算總金額
            let totalPrice = distance / fuelEfficiency * gasolinePrice + tollFee
            totalPriceLabel.text = String(format: "%.0f", totalPrice) + "円"
            // 計算每個人平均分攤金額
            let pricePerPerson = totalPrice / Double(numberOfPeople)
            pricePerPersonLabel.text = String(format: "%.0f", pricePerPerson) + "円"
        }
        
        // 按下Calculate按鈕後收鍵盤
        view.endEditing(true)
    }
    
    func showAlert(_ textFieldName: String) {
        let alertController = UIAlertController(title: nil, message: "\(textFieldName)を入力ください", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func addTextFieldToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(named: "mediumBlue")
        toolbar.isTranslucent = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTapView))
        doneButton.tintColor = .white
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        gasolinePriceTextField.inputAccessoryView = toolbar
        fuelEfficiencyTextField.inputAccessoryView = toolbar
        distanceTextField.inputAccessoryView = toolbar
        tollFeeTextField.inputAccessoryView = toolbar
    }
    
    @IBAction func goBackToMainView(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func selectGasolinePrice(_ segue: UIStoryboardSegue) {
        gasolinePriceTextField.text = String(format: "%.1f", gasolinePrice)
        updateGasolinePriceInUserDefault()
    }
    
    @IBAction func selectFuelEfficiency(_ segue: UIStoryboardSegue) {
        fuelEfficiencyTextField.text = String(format: "%.1f", fuelEfficiency)
        updateFuelEfficiencyInUserDefault()
    }
    
}


extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "\(row+1)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return attributedString
    }
    
    
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if text == "0" && string != "." {
            textField.text = string
            return false
        } else if text == "" && string == "." {
            return false
        } else if text.contains(".") && string == "." {
            return false
        } else {
            return true
        }
    }
}
