//
//  ServerWeather.swift
//  Lesson17
//
//  Created by Алексей Алексеев on 03.06.2021.
//

import Foundation

struct ServerWeather: Decodable {
    let fact: Fact
}

struct Fact: Decodable {
    let temp: Int
    let icon: String
    let condition: String
    let windSpeed: Float
    let windDir: String
    let pressureMm: Int
    let humidity: Int
}
