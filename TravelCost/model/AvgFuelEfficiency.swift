//
//  FuelEfficiency.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import Foundation

struct AvgFuelEfficiencyData: Codable {
    let fuel: Fuel
    struct Fuel: Codable {
        let normal: Double
        let light: Double
    }
}

struct AvgFuelEfficiency: Codable {
    var normal: Double
    var light: Double
}
