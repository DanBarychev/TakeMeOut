//
//  BusinessViewController.swift
//  Take Me Out
//
//  Created by Daniel Barychev on 9/10/16.
//
//

import UIKit
import YelpAPISwift
import Lyft
import CoreLocation
import MapKit

class PlaceViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placeCategoryLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var lyftButton: UIButton!
    @IBOutlet weak var somethingElseButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    let locationManager = CLLocationManager()
    //Initial coordinates
    var myCoordinates = CLLocationCoordinate2D(latitude: 39.951602, longitude: -75.191085)
    //An array of all my possible places
    var result = [Business]()
    //The index of our result array
    var selectedIndex = 0
    //Library of recommendation data
    var ratingLibrary = [String: Int]()
    
    //The user settings
    var settings = Settings(restaurants: true, arts: true, fitness: true)
    
    override func viewDidLoad() {
        //Retrieving user settings
        if let savedSettings = loadSettings() {
            settings = savedSettings
        }
        //User location setup
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //The yelp search
        yelpSearch()
    }
    
    // CLLocationManager Delegate method
    func locationManager(manager: CLLocationManager, didUpdateLocations: [CLLocation]) {
        let location: CLLocationCoordinate2D = (manager.location?.coordinate)!
        myCoordinates = location
        print("latitude: \(location.latitude), longitude : \(location.longitude)")
    }
    
    func yelpSearch() {
        activityIndicatorView.startAnimating()
        
        if (settings?.restaurants != false) {
            searchForRestaurants()
        }
        if (settings?.arts != false) {
            searchForTheArts()
        }
        if (settings?.fitness != false) {
            searchForFitness()
        }
        
        searchForNightlife()
        
        print(result.count)
        
        for i in result {
           print(i.name)
        }
    }
    
    func searchForRestaurants() {
        var restaurants = [Business]()

        let params = SearchParameters(term: "Restaurant", location: .Coordinate(GeographicCoordinate(latitude: myCoordinates.latitude, longitude: myCoordinates.longitude)))
        
        Business.search(params) {response, error in
            if (error == nil) {
                
            }
            else { print(error)}
            
            restaurants = response!.businesses
            
            self.addToResult(restaurants)
        }
    }
    
    func searchForTheArts() {
        var venues = [Business]()
        
        let params = SearchParameters(term: "Arts & Entertainment", location: .Coordinate(GeographicCoordinate(latitude: myCoordinates.latitude, longitude: myCoordinates.longitude)))
        
        Business.search(params) {response, error in
            if (error == nil) {
                
            }
            else { print(error)}
            
            venues = response!.businesses
            
            self.addToResult(venues)
        }
    }
    
    func searchForFitness() {
        var place = [Business]()
        
        let params = SearchParameters(term: "Active Life", location: .Coordinate(GeographicCoordinate(latitude: myCoordinates.latitude, longitude: myCoordinates.longitude)))
        
        Business.search(params) {response, error in
            if (error == nil) {
                
            }
            else { print(error)}
            
            place = response!.businesses
            
            self.addToResult(place)
        }
    }
    
    func searchForNightlife() {
        var restaurants = [Business]()
        
        let params = SearchParameters(term: "Restaurant", location: .Coordinate(GeographicCoordinate(latitude: myCoordinates.latitude, longitude: myCoordinates.longitude)))
        
        Business.search(params) {response, error in
            if (error == nil) {
                
            }
            else { print(error)}
            
            restaurants = response!.businesses
            
            self.addToResult(restaurants)
            self.assignValues()
            
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func addToResult(businesses: [Business]) {
        for business in businesses {
            result.append(business)
        }
        print(result.count)
    }
    
    func assignValues() {
        let randomIndex1 = Int(arc4random_uniform(UInt32(result.count)))
        let randomIndex2 = Int(arc4random_uniform(UInt32(result.count)))
        let randomIndex3 = Int(arc4random_uniform(UInt32(result.count)))
        
        selectedIndex = calculateOptimalRecommendationIndex(randomIndex1, ri2: randomIndex2, ri3: randomIndex3)
        
        placeNameLabel.text = result[selectedIndex].name
        imageView.loadImageUsingCacheWithURLString(result[selectedIndex].imageURL)
        placeLocationLabel.text = result[selectedIndex].location.address[0]
        placeCategoryLabel.text = result[selectedIndex].categories[0].name
    }
    
    func calculateOptimalRecommendationIndex(ri1: Int, ri2: Int, ri3: Int) -> Int {
        var index1Sum = 0
        var index2Sum = 0
        var index3Sum = 0
        
        var selectedBusiness = result[ri1]
        if ratingLibrary[selectedBusiness.name] != nil {
            index1Sum += ratingLibrary[selectedBusiness.name]!
        }
        if ratingLibrary[selectedBusiness.categories[0].name] != nil {
            index1Sum += ratingLibrary[selectedBusiness.categories[0].name]!
        }
        selectedBusiness = result[ri2]
        if ratingLibrary[selectedBusiness.name] != nil {
            index2Sum += ratingLibrary[selectedBusiness.name]!
        }
        if ratingLibrary[selectedBusiness.categories[0].name] != nil {
            index2Sum += ratingLibrary[selectedBusiness.categories[0].name]!
        }
        selectedBusiness = result[ri3]
        if ratingLibrary[selectedBusiness.name] != nil {
            index3Sum += ratingLibrary[selectedBusiness.name]!
        }
        if ratingLibrary[selectedBusiness.categories[0].name] != nil {
            index3Sum += ratingLibrary[selectedBusiness.categories[0].name]!
        }

        if max(index1Sum, index2Sum, index3Sum) == index1Sum {
            return ri1
        }
        else if max(index1Sum, index2Sum, index3Sum) == index2Sum {
            return ri2
        }
        else {
            return ri3
        }
    }
    
    func clearAll() {
        placeNameLabel.text = ""
        placeLocationLabel.text = ""
        placeCategoryLabel.text = ""
    }
    
    func lyftSetup() {
        Lyft.set(clientId: "gAAAAABX1CvXPRKoOjvY30Gc9TXugKxBPCkG62dR4DI_UI8pJP5Wu-xfID3RfwC30dYlSoZT0_IFAnJ-wNWVHj-_-L_upT4s6CzytiGTq4lUqa25CjL_VSfNqDjz1udQOUqp-QwDXPzG2FRB3DhWgb96AWwR7SgpaxlubwUvrG0NAZ-HA3YcuZs=", clientSecret: "gtm4fdv90Pa6VpyekzargrPNOCyFd4JR", sandbox: true)
        Lyft.openLyftRide(rideType: .Line, destination: Address(lat: Float(myCoordinates.latitude), lng: Float(myCoordinates.longitude)))
    }
    
    // MARK: Actions
    
    @IBAction func like(sender: UIButton) {
        /*let selectedBusiness = result[selectedIndex]
        if ratingLibrary[selectedBusiness.name] != nil {
            ratingLibrary[selectedBusiness.name] = ratingLibrary[selectedBusiness.name]! + 1
        }
        else {
            ratingLibrary[selectedBusiness.name] = 1
        }
        if ratingLibrary[selectedBusiness.categories[0].name] != nil {
            ratingLibrary[selectedBusiness.categories[0].name] = ratingLibrary[selectedBusiness.categories[0].name]! + 1
        }
        else {
            ratingLibrary[selectedBusiness.categories[0].name] = 1
        } */
        
        clearAll()
        assignValues()
    }
    
    @IBAction func dislike(sender: UIButton) {
        /*let selectedBusiness = result[selectedIndex]
        if ratingLibrary[selectedBusiness.name] != nil {
            ratingLibrary[selectedBusiness.name] = ratingLibrary[selectedBusiness.name]! - 1
        }
        else {
            ratingLibrary[selectedBusiness.name] = -1
        }
        if ratingLibrary[selectedBusiness.categories[0].name] != nil {
            ratingLibrary[selectedBusiness.categories[0].name] = ratingLibrary[selectedBusiness.categories[0].name]! - 1
        }
        else {
            ratingLibrary[selectedBusiness.categories[0].name] = -1
        } */
        
        clearAll()
        assignValues()
    }
    
    @IBAction func lyftButtonPressed(sender: UIButton) {
        lyftSetup()
    }
    
    @IBAction func somethingElse(sender: UIButton) {
        clearAll()
        assignValues()
    }
    
    @IBAction func exit(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: NSCoding

    func loadSettings() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Settings.ArchiveURL.path!) as? Settings
    }
}
