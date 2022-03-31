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
    
    @IBOutlet weak var textFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var numberOfPeopleStack: UIStackView!
    
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var numberOfPeople: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGasolinePrice()
        fetchFuelEfficiency()
        
        // Picker View
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
        
        // User Default
        getUserDefaultValues()
        gasolinePriceTextField.text = String(format: "%.0f", gasolinePrice)
        fuelEfficiencyTextField.text = String(format: "%.1f", fuelEfficiency)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // hide top car image view for devices with small screens
        if carImageView.bounds.height < 100 {
            carImageView.isHidden = true
            textFieldWidthConstraint.constant = 60
            pickerViewWidthConstraint.constant = 60
            numberOfPeopleStack.spacing = 10
        }
    }
    
    // MARK: - Button
    
    @IBAction func calculate(_ sender: Any) {
        // haptic feedback
        feedbackGenerator.selectionChanged()
        
        //  check if gasoline price & fuel efficiency fields is filled
        guard let gasolinePrice = Double(gasolinePriceTextField.text!) else {
            showAlert("ガソリン価格")
            return
        }
        guard let fuelEfficiency = Double(fuelEfficiencyTextField.text!) else {
            showAlert("燃費")
            return
        }
        // check distance & toll fee fields
        if Double(distanceTextField.text!) == nil {
            distanceTextField.text = "0"
        }
        if Double(tollFeeTextField.text!) == nil {
            tollFeeTextField.text = "0"
        }
        // get number of people value
        numberOfPeople = pickerView.selectedRow(inComponent: 0) + 1
        
        // calculate results
        if let distance = Double(distanceTextField.text!),
           let tollFee = Double(tollFeeTextField.text!) {
            // Claculate total price
            let totalPrice = distance / fuelEfficiency * gasolinePrice + tollFee
            totalPriceLabel.text = String(format: "%.0f", totalPrice) + "円"
            // Calculate price for each person
            let pricePerPerson = totalPrice / Double(numberOfPeople)
            pricePerPersonLabel.text = String(format: "%.0f", pricePerPerson) + "円"
        }
        
        // dismiss keyboard
        view.endEditing(true)
    }
    
    // MARK: - Segues
    @IBAction func goBackToMainView(_ segue: UIStoryboardSegue) {
        
    }
    @IBAction func selectGasolinePrice(_ segue: UIStoryboardSegue) {
        gasolinePriceTextField.text = getCleanNumber(text: String(gasolinePrice))
        updateGasolinePriceInUserDefault()
    }
    @IBAction func selectFuelEfficiency(_ segue: UIStoryboardSegue) {
        fuelEfficiencyTextField.text = getCleanNumber(text: String(fuelEfficiency))
        updateFuelEfficiencyInUserDefault()
    }

    // MARK: - Functions
    func showAlert(_ textFieldName: String) {
        let alertController = UIAlertController(title: nil, message: "\(textFieldName)をご入力ください", preferredStyle: .alert)
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissKeyboard))
        doneButton.tintColor = .white
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        gasolinePriceTextField.inputAccessoryView = toolbar
        fuelEfficiencyTextField.inputAccessoryView = toolbar
        distanceTextField.inputAccessoryView = toolbar
        tollFeeTextField.inputAccessoryView = toolbar
    }
    
    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(MainViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
}

// MARK: - Picker View
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

// MARK: - Text Field Delegate
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if text == "" && string == "." {
            return false
        } else if text.contains(".") && string == "." {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = getCleanNumber(text: textField.text!)
    }
    
}
