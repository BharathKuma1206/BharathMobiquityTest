//
//  ViewController.swift
//  BharathTest
//
//  Created by RAKSYS on 25/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var noLocation: UILabel!
    
    var tableViewData: [Location]?
    
    let viewModel = LocationListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableVW.register(UITableViewCell.self, forCellReuseIdentifier: "PlainCell")
        tableVW.tableFooterView = UIView()
        
        viewModel.bindLocationViewModelToController = { [weak self] in
            
            self?.tableViewData = self?.viewModel.locations
            
            DispatchQueue.main.async { [weak self] in
                
                if self?.tableViewData?.count == 0 {
                    
                    self?.noLocation.isHidden = false
                    self?.tableVW.isHidden = true

                } else {
                    
                    self?.noLocation.isHidden = true
                    self?.tableVW.isHidden = false
                    self?.tableVW.reloadData()
                }
            }
        }
        
        viewModel.getDataFromLocationEntity()

        
        viewModel.saveDataToLocationEntity(name: "Ram", latitude: 100, longitude: 100)
        
//        viewModel.fetchDetailsForTodayAndForecast(lat: 0, longi: 0) { (today, forecast) in
//
//            print(today, forecast)
//        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellData = tableViewData?[indexPath.row] else {
            
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        cell.textLabel?.text = cellData.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

