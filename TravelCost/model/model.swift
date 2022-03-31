//
//  model.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import Foundation

func decodeJsonData<T: Decodable>(_ data: Data) -> T? {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print(error)
        return nil
    }
}

func fetchGasolinePrice() {
    let urlString = "https://codebear.pythonanywhere.com/gasoline"
    if let url = URL(string: urlString) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let gasolineData: GasolineData = decodeJsonData(data) {
                    gasoline.regular = Double(gasolineData.price.regular)?.rounded() ?? gasoline.regular
                    gasoline.highOctane = Double(gasolineData.price.highOctane)?.rounded() ?? gasoline.highOctane
                    gasoline.lightOil = Double(gasolineData.price.lightOil)?.rounded() ?? gasoline.lightOil
                }
            }
        }.resume()
    }
}

func fetchFuelEfficiency() {
    let urlString = "https://codebear.pythonanywhere.com/fuel"
    if let url = URL(string: urlString) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let avgFuelEfficiencyData: AvgFuelEfficiencyData = decodeJsonData(data) {
                    avgFuelEfficiency.normal = avgFuelEfficiencyData.fuel.normal
                    avgFuelEfficiency.light = avgFuelEfficiencyData.fuel.light
                }
            }
        }.resume()
    }
}

func getCleanNumber(text: String) -> String {
    if let value = Double(text) {
        if Int((value*10).rounded())%10 == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
    return String()
}
