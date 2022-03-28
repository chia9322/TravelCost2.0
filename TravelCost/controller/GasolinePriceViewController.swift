//
//  GasolinePriceViewController.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import UIKit

class GasolinePriceViewController: UIViewController {

    @IBOutlet var regularButton: UIButton!
    @IBOutlet var highOctaneButton: UIButton!
    @IBOutlet var lightOilButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var regularLabel: UILabel!
    @IBOutlet var highOctaneLabel: UILabel!
    @IBOutlet var lightOilLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regularButton.layer.cornerRadius = regularButton.frame.height/2
        highOctaneButton.layer.cornerRadius = highOctaneButton.frame.height/2
        lightOilButton.layer.cornerRadius = lightOilButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        
        regularLabel.text = String(format: "%.0f", gasoline.regular) + "円"
        highOctaneLabel.text = String(format: "%.0f", gasoline.highOctane) + "円"
        lightOilLabel.text = String(format: "%.0f", gasoline.lightOil) + "円"
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender {
        case regularButton: gasolinePrice = gasoline.regular
        case highOctaneButton: gasolinePrice = gasoline.highOctane
        case lightOilButton: gasolinePrice = gasoline.lightOil
        default: break
        }
        performSegue(withIdentifier: "selectGasolinePrice", sender: nil)
    }

}
