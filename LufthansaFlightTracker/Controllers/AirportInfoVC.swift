//
//  AirportInfoVC.swift
//  LufthansaFlightTracker
//
//  Created by Vaibhav Gattani on 12/10/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import UIKit

class AirportInfoVC: UIViewController {

    var airport: Airport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigation() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Cloud")!)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.13, green:0.18, blue:0.48, alpha:1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = airport.airportName
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
