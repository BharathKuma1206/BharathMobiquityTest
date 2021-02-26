//
//  LocationDetails.swift
//  BharathTest
//
//  Created by RAKSYS on 26/02/21.
//

import UIKit

class LocationDetails: UIViewController {
    
    var todayWeatherModel: TodayWeatherModel?

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainChances: UILabel!
    @IBOutlet weak var windInformation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    func updateUI() {
        
        guard let todayWeatherModel = todayWeatherModel else { return }

        temperatureLabel.text = (todayWeatherModel.main?.temp?.toString() ?? "") + " " +  (WeatherUnits(rawValue: UserDefaultsConfig.unitsValue)?.temperatureUnits ?? "")
        humidityLabel.text = todayWeatherModel.main?.humidity?.toString() ?? ""
        rainChances.text = "\(todayWeatherModel.weather?.first?.main?.lowercased() == "rain" ? "Yes" : "No")"
        windInformation.text = (todayWeatherModel.wind?.speed?.toString() ?? "") + " " + (WeatherUnits(rawValue: UserDefaultsConfig.unitsValue)?.windSpeedUnits ?? "")
    }
}

enum WeatherUnits: String {
    
    case defaultString = "Default"
    case metric = "Metric"
    case imperial = "Imperial"
    
    var temperatureUnits: String {
        
        switch self {

        case .defaultString:
            return "Kelvin"
        case .metric:
            return "Celsius"
        case .imperial:
            return "Fahrenheit"
        }
    }
    
    var windSpeedUnits: String {
        
        switch self {

        case .defaultString:
            return "meter/sec"
        case .metric:
            return "meter/sec"
        case .imperial:
            return "miles/hour"
        }
    }
}

enum WindUnits: String {
    
    case defaultString = "Default"
    case metric = "Metric"
    case imperial = "Imperial"
    
    static let allTypes = [WindUnits.defaultString, .metric, .imperial]
    
    var unitsName: String? {
        
        switch self {

        case .defaultString:
            return "Kelvin"
        case .metric:
            return "Celsius"
        case .imperial:
            return "Fahrenheit"
        }
    }
}

extension Double {
    
    func toString() -> String {
        
        if self == 0 {
            
            return ""
            
        } else {
            
            return "\(self)"
        }
    }
}

extension Int {
    
    func toString() -> String {
        
        if self == 0 {
            
            return ""
            
        } else {
            
            return "\(self)"
        }
    }
}
