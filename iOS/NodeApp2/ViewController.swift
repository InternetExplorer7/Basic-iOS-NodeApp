//
//  ViewController.swift
//  NodeApp2
//
//  Created by Kaveh Khorram on 10/23/15.
//  Copyright © 2015 Kaveh Khorram. All rights reserved.
//


import UIKit
import AVFoundation
import CoreLocation
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var player = AVPlayer() // Audio Player
    let locationManager = CLLocationManager() // Location Manager
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var currentLoc = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "startload", userInfo: nil, repeats: true) // Loop start
    }
    
    
    @IBAction func Rest(sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.startload("restaurant")
        })
    }
    
    @IBAction func atm(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.startload("atm")
        })
    }
    
    @IBAction func shoppingmall(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.startload("shopping_mall")
        })
    }
    
    @IBAction func busstation(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.startload("bus_station")
        })
    }
    @IBAction func clothingstore(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.startload("clothing_store")
        })
    }
    
    @IBAction func gasstation(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.startload("gas_station")
        })
    }

    func startload(place: String){ // Starts the process, send recording data and location to node
        // GETS LOCATION
        print(place)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        print("Just req location")
        // GETS LOCATION
        // SENDS REQUEST
        // create the request & response
        let request = NSMutableURLRequest(URL: NSURL(string: "https://0fa30fcc.ngrok.io/ios")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var response: NSURLResponse?
            
        
        // create some JSON data and configure the request
        print("preping json")
        let jsonString = "json={\"location\":\"\(currentLoc)\", \"Place\": \" \(place) \"}"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // send the request
        print("Sending the request")
        do{
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            let datastring = NSString(data: data, encoding:NSUTF8StringEncoding)
            print("Datastring: \(datastring!)")
            sleep(15)
            PlayAudio(datastring! as String)
        } catch let error {
            print(error)
        }
        // look at the response
        //print("The response: \(response)")
        if let httpResponse = response as? NSHTTPURLResponse {
            print("HTTP response: \(httpResponse.statusCode)")
        } else {
            print("No HTTP response")
        }
        // SENDS REQUEST
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Inside LocationManager")
        if let location = locations.first {
            currentLoc = String(location)
        } else {
            // ...
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    
    
    
    func PlayAudio(addr: String){
        print("Got here \(addr)")
        let url = NSURL(string: addr)!
        let playerItem = AVPlayerItem( URL:url)
        player = AVPlayer(playerItem:playerItem)
        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

