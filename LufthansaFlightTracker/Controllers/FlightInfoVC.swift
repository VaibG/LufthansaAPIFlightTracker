//
//  FlightInfoVC.swift
//  LufthansaFlightTracker
//
//  Created by Vaibhav Gattani on 12/10/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit

class FlightInfoVC: UIViewController {

    var flt: Flight!
    var favoriteButton: UIButton!
    var departure: UILabel!
    var arrival: UILabel!
    var status: UILabel!
    var departureDate: UILabel!
    var arrivalDate: UILabel!
    var departureTime: UILabel!
    var arrivalTime: UILabel!
    var actualDepartedTime: UILabel!
    var actualArrivalTime: UILabel!
    var departureAirport: UILabel!
    var arrivalAirport: UILabel!
    var aircraftType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        favoriteButton.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }
    
    func setupNavigation() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.18, blue:0.48, alpha:1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = flt.flightNumber
        favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        favoriteButton.setTitle("Favorites", for: .normal)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.addTarget(self, action: #selector(saveFlight), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    
    func setupUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Cloud")!)

        status = UILabel(frame: CGRect(x: 10, y: (self.navigationController?.navigationBar.frame.maxY)! + 10, width: view.frame.width - 20, height: 40))
        status.text = flt.status
        status.font = UIFont(name: "AvenirNext-Heavy", size: 34)
        status.textAlignment = .center
        view.addSubview(status)
        
        
        
        departure = UILabel(frame: CGRect(x: 10, y: status.frame.maxY + 30, width: view.frame.width - 20, height: 30))
        departure.text = "Departure"
        departure.font = UIFont(name: "AvenirNext-Heavy", size: 26)
        departure.textAlignment = .center
        view.addSubview(departure)
        
        departureAirport = UILabel(frame: CGRect(x: 0, y: departure.frame.maxY + 10, width: view.frame.width/3, height: 50))
        departureAirport.numberOfLines = 0
        departureAirport.text = "Airport: \n" + flt.departureAirport!
        departureAirport.font = UIFont(name: "AvenirNext-Bold", size: 18)
        departureAirport.textAlignment = .center
        view.addSubview(departureAirport)
        
        departureDate = UILabel(frame: CGRect(x: view.frame.width/3, y: departure.frame.maxY + 10, width: view.frame.width/3, height: 50))
        departureDate.numberOfLines = 0
        departureDate.text = "Date: \n" + flt.date!
        departureDate.font = UIFont(name: "AvenirNext-Bold", size: 18)
        departureDate.textAlignment = .center
        view.addSubview(departureDate)
        
        departureTime = UILabel(frame: CGRect(x: 2*view.frame.width/3, y: departure.frame.maxY + 10, width: view.frame.width/3, height: 50))
        departureTime.numberOfLines = 0
        let x = parseTime(flt.departureTime!)
        departureTime.text = "Time: \n" + x
        departureTime.font = UIFont(name: "AvenirNext-Bold", size: 18)
        departureTime.textAlignment = .center
        view.addSubview(departureTime)
        
        arrival = UILabel(frame: CGRect(x: 10, y: departureTime.frame.maxY + 20, width: view.frame.width - 20, height: 30))
        arrival.text = "Arrival"
        arrival.font = UIFont(name: "AvenirNext-Heavy", size: 26)
        arrival.textAlignment = .center
        view.addSubview(arrival)
        
        arrivalAirport = UILabel(frame: CGRect(x: 0, y: arrival.frame.maxY + 10, width: view.frame.width/3, height: 50))
        arrivalAirport.numberOfLines = 0
        arrivalAirport.text = "Airport: \n" + flt.arrivalAirport!
        arrivalAirport.font = UIFont(name: "AvenirNext-Bold", size: 18)
        arrivalAirport.textAlignment = .center
        view.addSubview(arrivalAirport)
        
        arrivalDate = UILabel(frame: CGRect(x: view.frame.width/3, y: arrival.frame.maxY + 10, width: view.frame.width/3, height: 50))
        arrivalDate.numberOfLines = 0
        arrivalDate.text = "Date: \n" + flt.date!
        arrivalDate.font = UIFont(name: "AvenirNext-Bold", size: 18)
        arrivalDate.textAlignment = .center
        view.addSubview(arrivalDate)
        
        arrivalTime = UILabel(frame: CGRect(x: 2*view.frame.width/3, y: arrival.frame.maxY + 10, width: view.frame.width/3, height: 50))
        arrivalTime.numberOfLines = 0
        let y = parseTime(flt.arrivalTime!)
        arrivalTime.text = "Time: \n" + y
        arrivalTime.font = UIFont(name: "AvenirNext-Bold", size: 18)
        arrivalTime.textAlignment = .center
        view.addSubview(arrivalTime)
        
        
        
        
    }
    
    func parseTime(_ time: String) -> String {
        print(time)
        let start = time.index(time.endIndex, offsetBy: -5)
        let end = time.index(time.endIndex, offsetBy: 0)
        let range = start..<end
        return String(time[range])

    }
    
    @objc func saveFlight() {
        favoriteButton.isUserInteractionEnabled = false
        let defaults = UserDefaults.standard
        defaults.set(flt.date, forKey: "flightDate")
        defaults.set(flt.flightNumber, forKey: "flightNumber")
        
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
