//
//  FuelEfficiencyViewController.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import UIKit

class FuelEfficiencyViewController: UIViewController {

    @IBOutlet var lightButton: UIButton!
    @IBOutlet var normalButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet var lightLabel: UILabel!
    @IBOutlet var normalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightButton.layer.cornerRadius = lightButton.frame.height/2
        normalButton.layer.cornerRadius = normalButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        
        lightLabel.text = getCleanNumber(text: String(avgFuelEfficiency.light)) + "km / L"
        normalLabel.text = getCleanNumber(text: String(avgFuelEfficiency.normal)) + "km / L"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender {
        case lightButton: fuelEfficiency = avgFuelEfficiency.light
        case normalButton: fuelEfficiency = avgFuelEfficiency.normal
        default: break
        }
        performSegue(withIdentifier: "selectFuelEfficiency", sender: nil)
    }
    
}
