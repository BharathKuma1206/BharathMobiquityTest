//
//  LocationDetails.swift
//  BharathTest
//
//  Created by RAKSYS on 26/02/21.
//

import UIKit

class LocationDetails: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum WeatherUnits: String {
    
    case defaultString = "Default"
    case metric = "Metric"
    case imperial = "Imperial"
    
    var temperatureUnits: String? {
        
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
