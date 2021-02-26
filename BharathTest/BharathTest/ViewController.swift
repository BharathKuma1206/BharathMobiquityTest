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
    let searchController = UISearchController(searchResultsController: nil)
    
    let viewModel = LocationListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableVW.register(UITableViewCell.self, forCellReuseIdentifier: "PlainCell")
        tableVW.tableFooterView = UIView()
        
        setupSearchController()
        
        viewModel.bindLocationViewModelToController = { [weak self] in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                if self.viewModel.tableViewData?.count ?? 0 == 0 {
                    
                    self.noLocation.isHidden = false
                    self.tableVW.isHidden = true
                    
                } else {
                    
                    self.noLocation.isHidden = true
                    self.tableVW.isHidden = false
                    self.tableVW.reloadData()
                }
            }
        }
        
        viewModel.getDataFromLocationEntity()
    }
    
    func setupSearchController() {
        
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search by Location name"
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableVW.tableHeaderView = searchController.searchBar
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.tableViewData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellData = viewModel.tableViewData?[indexPath.row] else {
            
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
            
            guard let cellData = viewModel.tableViewData?[indexPath.row] else { return }
            
            let isSucess = viewModel.deleteDataFromLocationEntity(location: cellData, indexRow: indexPath.row)
            
            if !isSucess {
                
                self.showErrorAlert()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cellData = viewModel.tableViewData?[indexPath.row] else { return }
        
        viewModel.fetchDetailsForTodayAndForecast(lat: Float(cellData.latitudeValue), longi: Float(cellData.longitudeValue)) { (today, forecast) in
            
            
            
        }
    }
}

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HomeToAdd" {
            
            guard let destination = (segue.destination as? UINavigationController)?.topViewController as? AddLocationVC else {
                
                return
            }
            destination.allLocations = viewModel.locations
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

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let term = searchController.searchBar.text {
            
            filterRowsForSearchedText(term)
            
        } else {
            
            viewModel.isSearching = false
            viewModel.searchLocations = []
        }
    }
    
    func filterRowsForSearchedText(_ searchText: String) {
        
        if searchText != "" {
            
            viewModel.isSearching = true
            viewModel.searchLocations = viewModel.locations?.filter({($0.name?.lowercased().contains(searchText.lowercased()) ?? false)})
            
        } else {
            
            viewModel.isSearching = false
            viewModel.searchLocations = []
        }
    }
}


extension UIViewController {
    
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        
        showAlert(message: "Some thing went wrong")
    }
}
