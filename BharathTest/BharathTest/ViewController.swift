//
//  ViewController.swift
//  BharathTest
//
//  Created by RAKSYS on 25/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel: LocationListVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        viewModel = LocationListVM()
        viewModel.bindLocationViewModelToController = { [weak self] in
            
            print(self?.viewModel.locations)
        }
        
        viewModel.saveDataToLocationEntity(name: "Ram", latitude: 100, longitude: 100)
        
        viewModel.fetchDetailsForTodayAndForecast(lat: 0, longi: 0) { (today, forecast) in
            
            print(today, forecast)
        }
    }
}

