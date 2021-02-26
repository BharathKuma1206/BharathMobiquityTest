//
//  SettingsVC.swift
//  BharathTest
//
//  Created by RAKSYS on 26/02/21.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var unitsValue: UILabel!
    var resetButtonClicked: (() -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        unitsValue.text = UserDefaultsConfig.unitsValue
    }
    

    @IBAction func resetAllData(_ sender: Any) {
        
        resetButtonClicked?()
        UserDefaultsConfig.unitsValue = WeatherUnits.defaultString.rawValue
    }
}
