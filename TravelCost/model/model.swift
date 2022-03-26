//
//  model.swift
//  TravelCost
//
//  Created by Chia on 2022/03/25.
//

import Foundation

func decodeJsonData<T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError()
    }
}

func fetchGasolinePrice() {
    let urlString = "https://codebear.pythonanywhere.com/gasoline"
    if let url = URL(string: urlString) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let gasolineData: GasolineData = decodeJsonData(data)
                gasoline.regular = Double(gasolineData.price.regular) ?? gasoline.regular
                gasoline.highOctane = Double(gasolineData.price.highOctane) ?? gasoline.highOctane
                gasoline.lightOil = Double(gasolineData.price.lightOil) ?? gasoline.lightOil
            }
        }.resume()
    }
}
