//
//  TodayWeatherModel.swift
//  BharathMobiquityTest
//
//  Created by RAKSYS on 25/02/21.
//

import Foundation

// MARK: - TodayWeatherModel
struct TodayWeatherModel: Codable {
    let coord: TodayCoord?
    let weather: [TodayWeather]?
    let base: String?
    let main: TodayMain?
    let visibility: Int?
    let wind: TodayWind?
    let rain: TodayRain?
    let clouds: TodayClouds?
    let dt: Int?
    let sys: TodaySys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct TodayClouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct TodayCoord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct TodayMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct TodayRain: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct TodaySys: Codable {
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct TodayWeather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct TodayWind: Codable {
    let speed: Double?
    let deg: Int?
}
