//
//  UnitTypeListVC.swift
//  BharathTest
//
//  Created by RAKSYS on 26/02/21.
//

import UIKit

class UnitTypeListVC: UIViewController {

    @IBOutlet weak var tableVW: UITableView!
    
    var unitTypeClicked: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableVW.register(UITableViewCell.self, forCellReuseIdentifier: "PlainCell")
        tableVW.tableFooterView = UIView()
    }
}

extension UnitTypeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return WindUnits.allTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        cell.textLabel?.text = WindUnits.allTypes[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        cell.selectionStyle = .none
        
        if WindUnits.allTypes[indexPath.row].rawValue == UserDefaultsConfig.unitsValue {
            
            cell.accessoryType = .checkmark

        } else {
            
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaultsConfig.unitsValue != WindUnits.allTypes[indexPath.row].rawValue {
            
            UserDefaultsConfig.unitsValue = WindUnits.allTypes[indexPath.row].rawValue
            unitTypeClicked?()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
