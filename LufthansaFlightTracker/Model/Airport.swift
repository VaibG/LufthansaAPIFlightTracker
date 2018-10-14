//
//  Airport.swift
//  LufthansaFlightTracker
//
//  Created by Vaibhav Gattani on 12/10/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import Foundation
import ObjectMapper

class Airport {
    var airportName: String?
    var longitude: Double?
    var latitude: Double?
    var airportCode: String?
    var departureFlights: [String]?
    var arrivalFlights: [String]?
}
