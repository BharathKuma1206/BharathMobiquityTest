//
//  LocationListVM.swift
//  BharathTest
//
//  Created by RAKSYS on 25/02/21.
//

import Foundation
import UIKit
import CoreData

class LocationListVM {
    
    static let apiKeyForWeather = "fae7190d7e6433ec3a45285ffcf55c86"
    
    lazy var apiClient = APIClient()
    
    private(set) var locations: [Location]? {
        
        didSet {
            
            bindLocationViewModelToController()
        }
    }
    
    var bindLocationViewModelToController : (() -> ()) = {}
    
    func getDataFromLocationEntity() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        
        do {
            
            locations = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveDataToLocationEntity(name: String, latitude: Float, longitude: Float) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
        
        guard let location = NSManagedObject(entity: entity, insertInto: managedContext) as? Location else {
            
            return false
        }
        
        location.setValue(name, forKeyPath: "name")
        location.setValue(latitude, forKeyPath: "latitudeValue")
        location.setValue(longitude, forKeyPath: "longitudeValue")
        
        do {
            try managedContext.save()
            
            if locations != nil {
                
                locations?.append(location)
                
            } else {
                
                locations = [location]
            }
            return true
        } catch {
            return false
        }
    }
    
    func deleteDataFromLocationEntity(location: Location, indexRow: Int) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(location)
        do {
            
             try managedContext.save()
            locations?.remove(at: indexRow)
            return true
        } catch {
            
            return false
        }
    }
    
    func fetchDetailsForTodayAndForecast(lat: Float, longi: Float, completionHandler: @escaping((TodayWeatherModel?, FutureWeatherModel?) -> ())) {
        
        var todayWeatherModel: TodayWeatherModel?
        var futureWeatherModel: FutureWeatherModel?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchDetailsForToday(lat: lat, longi: longi) { todayData in
            
            todayWeatherModel = todayData
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchDetailsForForecast(lat: lat, longi: longi) { foreCastData in
            
            futureWeatherModel = foreCastData
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            completionHandler(todayWeatherModel, futureWeatherModel)
        }
    }
    
    private func fetchDetailsForToday(lat: Float, longi: Float, completionHandler: @escaping((TodayWeatherModel?) -> Void)) {
        
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(longi)&appid=\(LocationListVM.apiKeyForWeather)") else {
            
            completionHandler(nil)
            return
        }
        
        apiClient.makeGenericAPICall(url: url, resultType: TodayWeatherModel.self, handler: { data in
            
            switch data {
            case .success(let data):
                completionHandler(data)
            case .failure(_):
                completionHandler(nil)
            }
        })
    }
    
    private func fetchDetailsForForecast(lat: Float, longi: Float, completionHandler: @escaping((FutureWeatherModel?) -> Void)) {
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(longi)&appid=\(LocationListVM.apiKeyForWeather)&units=metric") else {
            
            completionHandler(nil)
            return
        }
        
        apiClient.makeGenericAPICall(url: url, resultType: FutureWeatherModel.self, handler: { data in
            
            switch data {
            case .success(let data):
                completionHandler(data)
            case .failure(_):
                completionHandler(nil)
            }
        })
    }
}
