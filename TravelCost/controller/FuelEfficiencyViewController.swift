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
    
    @IBOutlet var lightLabel: UILabel!
    @IBOutlet var normalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lightLabel.text = String(format: "%.1f", avgFuelEfficiency.light) + "km / L"
        normalLabel.text = String(format: "%.1f", avgFuelEfficiency.normal) + "km / L"
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
