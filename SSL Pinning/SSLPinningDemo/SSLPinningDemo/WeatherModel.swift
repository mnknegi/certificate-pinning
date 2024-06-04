//
//  WeatherModel.swift
//  SSLPinningDemo
//
//  Created by Mayank Negi on 31/05/24.
//

import Foundation

struct WeatherModel: Decodable {
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}
