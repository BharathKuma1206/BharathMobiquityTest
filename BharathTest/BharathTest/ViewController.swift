//
//  ViewController.swift
//  BharathTest
//
//  Created by RAKSYS on 25/02/21.
//

import UIKit
import CoreLocation

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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {

            guard let cellData = tableViewData?[indexPath.row] else { return }
            let isSucess = viewModel.deleteDataFromLocationEntity(location: cellData, indexRow: indexPath.row)
            if !isSucess {
                
                self.showErrorAlert()
            }
        }
    }
}

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HomeToAdd" {
            
            guard let destination = (segue.destination as? UINavigationController)?.topViewController as? AddLocationVC else {
                
                return
            }
            
            destination.addButtonClosure = { [weak self] cordinate, name in
                
                guard let self = self else {return}
                let isSucess = self.viewModel.saveDataToLocationEntity(name: name, latitude: Float(cordinate.latitude), longitude: Float(cordinate.longitude))
                
                if !isSucess {
                    
                    self.showErrorAlert()
                }
            }
        }
    }
}


extension UIViewController {
    
    func showErrorAlert() {
        
        let alertController = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
    }
}
