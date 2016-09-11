//
//  SettingsViewController.swift
//  Take Me Out
//
//  Created by Daniel Barychev on 9/10/16.
//
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Properties
    var newSettings: Settings?
    var mySettings = Settings(restaurants: true, arts: true, fitness: true)
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    @IBOutlet weak var restaurantsSwitch: UISwitch!
    @IBOutlet weak var artsSwitch: UISwitch!
    @IBOutlet weak var fitnessSwitch: UISwitch!
    
    override func viewDidLoad() {
        setCurrentSettings()
    }
    
    func setCurrentSettings() {
        if let currentSettings = loadSettings() {
            mySettings = currentSettings
        }
        
        restaurantsSwitch.setOn((mySettings?.restaurants)!, animated: true)
        artsSwitch.setOn((mySettings?.arts)!, animated: true)
        fitnessSwitch.setOn((mySettings?.fitness)!, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        newSettings?.restaurants
        if homeButton === sender {
            let restaurants = restaurantsSwitch.on
            let arts = artsSwitch.on
            let fitness = fitnessSwitch.on
            
            newSettings = Settings(restaurants: restaurants, arts: arts, fitness: fitness)
        }
    }
    
    // MARK: NSCoding
    
    func loadSettings() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Settings.ArchiveURL.path!) as? Settings
    }
}
