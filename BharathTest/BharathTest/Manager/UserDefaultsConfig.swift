//
//  APIClient.swift
//  BharathTest
//
//  Created by RAKSYS on 25/02/21.
//

import Foundation
struct UserDefaultsConfig {
    
    @UserDefaultsWrapper(key: "unitsValue", defaultValue: WeatherUnits.defaultString.rawValue)
    static var unitsValue: String
}
