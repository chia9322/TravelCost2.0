//
//  variables.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import Foundation

var gasoline: Gasoline = Gasoline(highOctane: 180, lightOil: 150, regular: 170)
var avgFuelEfficiency: AvgFuelEfficiency = AvgFuelEfficiency(normal: 12.0, light: 18.0)

var gasolinePrice: Double = 150
var fuelEfficiency: Double = 10

func getUserDefaultValues() {
    let userDefault = UserDefaults.standard
    gasolinePrice = userDefault.double(forKey: "gasolinePrice")
    fuelEfficiency = userDefault.double(forKey: "fuelEfficiency")
}

func updateGasolinePriceInUserDefault() {
    let userDefault = UserDefaults.standard
    userDefault.set(gasolinePrice, forKey: "gasolinePrice")
}

func updateFuelEfficiencyInUserDefault() {
    let userDefault = UserDefaults.standard
    userDefault.set(fuelEfficiency, forKey: "fuelEfficiency")
}

