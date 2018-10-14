//
//  ViewController.swift
//  LufthansaFlightTracker
//
//  Created by Vaibhav Gattani on 9/10/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class FlightStatusVC: UIViewController {
    
    var mainHeader: UILabel!
    var inputFlight: SkyFloatingLabelTextField!
    var pickDate: UIDatePicker!
    var searchButton: UIButton!
    var selectedDate: String!
    var sendFlight: Flight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = UIColor(red:0.93, green:0.75, blue:0.11, alpha:1.0)
        self.tabBarController?.tabBar.alpha = 0.7
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        searchButton.isUserInteractionEnabled = true
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        mainHeader = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        mainHeader.text = "Flight Tracker"
        mainHeader.textAlignment = .center
        mainHeader.center = CGPoint(x: view.frame.width/2, y: 100)
        mainHeader.font = UIFont(name: "AvenirNext-Heavy", size: 34)
        mainHeader.textColor = UIColor.white
        view.addSubview(mainHeader)
        
        inputFlight = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: 40))
        inputFlight.placeholder = "Input Flight Number"
        inputFlight.title = "Flight Number"
        inputFlight.font = UIFont(name: "AvenirNext-Bold", size: 16)
        inputFlight.selectedTitleColor = UIColor(red:0.13, green:0.18, blue:0.48, alpha:1.0)
        inputFlight.selectedLineColor = UIColor(red:0.13, green:0.18, blue:0.48, alpha:1.0)
        inputFlight.textColor = .white
        inputFlight.center = CGPoint(x: view.frame.width/2, y: 180)
        view.addSubview(inputFlight)
        
        pickDate = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: 200))
        pickDate.center = CGPoint(x: view.frame.width/2, y: 340)
        pickDate.datePickerMode = .date
        pickDate.setValue(UIColor(red:0.13, green:0.18, blue:0.48, alpha:1.0), forKey: "textColor")
        view.addSubview(pickDate)
        
        searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: 50))
        searchButton.center = CGPoint(x: view.frame.width/2, y: 500)
        searchButton.setTitle("Search Flight", for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        searchButton.backgroundColor = UIColor(red:0.13, green:0.18, blue:0.48, alpha:1.0)
        searchButton.layer.cornerRadius = 20
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        view.addSubview(searchButton)
    
    }
    
    @objc func searchButtonPressed() {
        searchButton.isUserInteractionEnabled = false
        guard let flgtNum = inputFlight.text, !flgtNum.isEmpty else {
            searchButton.isUserInteractionEnabled = true
            displayAlert(title: "Invalid Input", message: "Please Enter A Flight Number")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: pickDate.date)
        print(selectedDate)
        LufthansaAPIHelper.getAuthToken() {
            LufthansaAPIHelper.getFlightStatus(view: self, flightNum: flgtNum, date: self.selectedDate) { flt in
                self.sendFlight = flt
                self.inputFlight.text = ""
                self.performSegue(withIdentifier: "toInfoPage", sender: nil)
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FlightInfoVC {
            destination.flt = sendFlight
        }
        
    }


}

