//
//  Gasoline.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import Foundation

struct GasolineData: Codable {
    let time: String
    let price: Price
    struct Price: Codable {
        let highOctane: String
        let lightOil: String
        let regular: String
    }
}

struct Gasoline {
    var highOctane: Double
    var lightOil: Double
    var regular: Double
}
