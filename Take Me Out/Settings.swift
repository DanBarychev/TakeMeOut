//
//  Settings.swift
//  Take Me Out
//
//  Created by Daniel Barychev on 9/10/16.
//
//

import UIKit

public class Settings: NSObject, NSCoding {
    // MARK: Properties
    
    init?(restaurants: Bool, arts: Bool, fitness:Bool) {
        // Initialize stored properties.
        self.restaurants = restaurants
        self.arts = arts
        self.fitness = fitness
        
        super.init()
    }
    
    var restaurants: Bool?
    var arts: Bool?
    var fitness: Bool?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    // MARK: Types
    
    struct PropertyKey {
        static let restaurantsKey = "restaurants"
        static let artsKey = "arts"
        static let fitnessKey = "fitness"
    }
    
    // MARK: NSCoding
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(restaurants, forKey: PropertyKey.restaurantsKey)
        aCoder.encodeObject(arts, forKey: PropertyKey.artsKey)
        aCoder.encodeObject(fitness, forKey: PropertyKey.fitnessKey)
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let restaurants = aDecoder.decodeObjectForKey(PropertyKey.restaurantsKey) as! Bool
        let arts = aDecoder.decodeObjectForKey(PropertyKey.artsKey) as! Bool
        let fitness = aDecoder.decodeObjectForKey(PropertyKey.fitnessKey) as! Bool
        
        self.init(restaurants: restaurants, arts: arts, fitness: fitness)
    }
}
