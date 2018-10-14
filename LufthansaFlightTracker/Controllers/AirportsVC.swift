//
//  AirportsVC.swift
//  LufthansaFlightTracker
//
//  Created by Vaibhav Gattani on 10/10/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit
import MapKit

class AirportsVC: UIViewController {
    
    var twentyAirports: [Airport]!
    var mapView: MKMapView!
    var sendAirport: Airport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAirports()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getAirports() {
        LufthansaAPIHelper.getAuthToken() {
            LufthansaAPIHelper.getAirport(view: self) {airpor in
                self.twentyAirports = airpor
                self.createMap()
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createMap() {
        mapView = MKMapView(frame: view.frame)
        for airport in twentyAirports {
            let location = CLLocationCoordinate2D(latitude: airport.latitude!,
                longitude: airport.longitude!)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = airport.airportName
            annotation.subtitle = airport.airportCode
            //let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Airport")
            //annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            mapView.addAnnotation(annotation)
        }
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 21.282778,longitude: 10.829444), span: span)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        view.addSubview(mapView)
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

extension AirportsVC: MKMapViewDelegate {
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Airport"
        var view: MKAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }*/
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        for airport in twentyAirports {
            if view.annotation?.title == airport.airportName {
                sendAirport = airport
            }
        }
        
        performSegue(withIdentifier: "toAirport", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AirportInfoVC {
            destination.airport = sendAirport
        }
        
    }
    
}
