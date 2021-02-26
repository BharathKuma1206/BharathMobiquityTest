//
//  AddLocationVC.swift
//  BharathTest
//
//  Created by RAKSYS on 26/02/21.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {

    @IBOutlet weak var mapVW: MKMapView!
    
    var allLocations: [Location]?
    
    var addButtonClosure: ((CLLocationCoordinate2D, String) -> ())?
    
    var cordinates = CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let span = MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75)
        let region = MKCoordinateRegion(center: cordinates, span: span)
        mapVW.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapVW.region.center // instead of myMap.centerCoordinate
        mapVW.addAnnotation(annotation)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapVW.addGestureRecognizer(gestureRecognizer)
    }
    

    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        mapVW.removeAnnotations(mapVW.annotations)
        
        let location = gestureRecognizer.location(in: mapVW)
        let coordinate = mapVW.convert(location, toCoordinateFrom: mapVW)
        
        cordinates = coordinate
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapVW.addAnnotation(annotation)
    }
}

extension AddLocationVC {
 
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        if allLocations?.filter({$0.latitudeValue ==  Float(cordinates.latitude) && Float(cordinates.longitude) == $0.longitudeValue }).first != nil {
            
            showAlert(message: "Location already added")
            return
        }
        
        geocode(latitude: cordinates.latitude, longitude: cordinates.longitude) { [weak self] (places, error) in
            
            guard let self = self else { return }
            if error == nil &&  places != nil && places?.first != nil {
                
                self.addButtonClosure?(self.cordinates, places?.first?.locality ?? "Un Known")
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                self.showErrorAlert()
            }
        }
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
}
