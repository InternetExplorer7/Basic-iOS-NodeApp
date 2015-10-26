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

class secondview: UIViewController, CLLocationManagerDelegate {
    var player = AVPlayer() // Audio Player
    let locationManager = CLLocationManager() // Location Manager
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var currentLoc = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "startload", userInfo: nil, repeats: true) // Loop start
    }
    
    func startload(place: String){ // Starts the process, send recording data and location to node
        // GETS LOCATION
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        // GETS LOCATION
        // SENDS REQUEST
        // create the request & response
        let request = NSMutableURLRequest(URL: NSURL(string: "https://4890adf2.ngrok.io/ios")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        
        // create some JSON data and configure the request
        
        let jsonString = "json={\"location\":\"\(currentLoc)\", \"Place\": \" \(place) \"}"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // send the request
        do{
        let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        let datastring = NSString(data: data, encoding:NSUTF8StringEncoding)
        print("Datastring: \(datastring!)")
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
        if let location = locations.first {
            currentLoc = String(location)
            print("CurrentLoc set: \(currentLoc)")
            print("Current location: \(location)")
        } else {
            // ...
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    
    
    
    func PlayEntryAudio(){
        print("Got here")
        let url = NSURL(string: "https://9147abb4.ngrok.io/track.mp4")!
        let playerItem = AVPlayerItem( URL:url)
        player = AVPlayer(playerItem:playerItem)
        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

