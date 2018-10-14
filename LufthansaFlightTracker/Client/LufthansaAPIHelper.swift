//
//  LufthansaAPIHelper.swift
//  LufthansaFlightTracker
//
//  Created by Vaibhav Gattani on 10/10/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LufthansaAPIHelper {
    
    //These are where we will store all of the authentication information. Get these from your account at developer.lufthansa.com.
    static let clientSecret = "5ffY9Y7GnW"
    static let clientID = "4kaj48pwtppvwkhharsat2bt"
    
    //This variable will store the session's auth token that we will get from getAuthToken()
    static var authToken: String?
    
    //This function will request an auth token from the lufthansa servers
    static func getAuthToken(completion: @escaping () -> ()){
        
        //This is the information that will be sent to the server to authenticate our device
        let requestURL = "https://api.lufthansa.com/v1/oauth/token"
        let parameters = ["client_id": "\(clientID)", "client_secret": "\(clientSecret)", "grant_type": "client_credentials"]
        
        //This is the POST request made to the lufthansa servers to get the authToken for this session.
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding(), headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON { response in
            
            //Converts response to JSON object and sets authToken variable to appropriate value
            let json = JSON(response.result.value!)
            self.authToken = json["access_token"].stringValue
            
            print("Auth token: " + self.authToken!)
            print("This key expires in " + json["expires_in"].stringValue + " seconds\n")
            
            //Runs completion closure
            completion()
        }
    }
    
    //This function will get the status for a flight. FlightNum format "LHXXX" Date format "YYYY-MM-DD"
    static func getFlightStatus(view: FlightStatusVC, flightNum: String, date: String, completion: @escaping (Flight) -> ()){
        
        //Request URL and authentication parameters
        let requestURL = "https://api.lufthansa.com/v1/operations/flightstatus/\(flightNum)/\(date)"
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
        
        print("PARAMETERS FOR REQUEST:")
        print(parameters)
        print("\n")
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            //Makes sure that response is valid
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            //Creates JSON object
            let json = JSON(response.result.value)
            print(json)
            if !json["FlightStatusResource"].exists() {
                view.searchButton.isUserInteractionEnabled = true
                if json["ProcessingErrors"]["ProcessingError"]["Type"].stringValue == "ResourceNotFound" {
                    view.displayAlert(title: "No Flight Found", message: "There were no flights with this flight number on this day")
                } else {
                    view.displayAlert(title: "Invalid Flight Number", message: "Please Enter A Valid Flight Number (e.g. LH004)")
                }
                return
            }
            //Create new flight model and populate data
            let flight = Flight()
            flight.flightNumber = flightNum
            flight.date = date
            flight.status = json["FlightStatusResource"]["Flights"]["Flight"]["FlightStatus"]["Definition"].stringValue
            flight.arrivalAirport = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["AirportCode"].stringValue
            flight.departureAirport = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["AirportCode"].stringValue
            flight.departureTime = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["ScheduledTimeLocal"]["DateTime"].stringValue
            flight.arrivalTime = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["ScheduledTimeLocal"]["DateTime"].stringValue
            flight.actualDepartedTime = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["ActualTimeLocal"]["DateTime"].stringValue
            flight.actualArrivalTime = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["ActualTimeLocal"]["DateTime"].stringValue
            flight.aircraftType = json["FlightStatusResource"]["Flights"]["Flight"]["Equipment"]["AircraftCode"].stringValue
            completion(flight)
        }
        
    }
    
    static func getAirport(view: AirportsVC, completion: @escaping ([Airport]) -> ()){
        
        //Request URL and authentication parameters
        let requestURL = "https://api.lufthansa.com/v1/references/airports/?limit=20&offset=0&LHoperated=0"
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
        
        print("PARAMETERS FOR REQUEST:")
        print(parameters)
        print("\n")
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            //Makes sure that response is valid
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            //Creates JSON object
            let json = JSON(response.result.value)
            if !json["AirportResource"].exists() {
                if json["ProcessingErrors"]["ProcessingError"]["Type"].stringValue == "ResourceNotFound" {
                    view.displayAlert(title: "No Airport Found", message: "There was an error loading the airports")
                } else {
                    view.displayAlert(title: "Invalid Airport Code", message: "Please Enter A Valid Airport Code (e.g. AAL)")
                }
                return
            }
            //Create new flight model and populate data
            var allAirports: [Airport] = []
            for x in 0..<20 {
                let airprt = Airport()
                airprt.airportCode = json["AirportResource"]["Airports"]["Airport"][x]["AirportCode"].stringValue
                airprt.airportName = json["AirportResource"]["Airports"]["Airport"][x]["Names"]["Name"][0]["$"].stringValue
                airprt.latitude = json["AirportResource"]["Airports"]["Airport"][x]["Position"]["Coordinate"]["Latitude"].doubleValue
                airprt.longitude = json["AirportResource"]["Airports"]["Airport"][x]["Position"]["Coordinate"]["Longitude"].doubleValue
                
                allAirports.append(airprt)
            }
            print("appended all airports")
            completion(allAirports)
        }
        
    }
    
}
