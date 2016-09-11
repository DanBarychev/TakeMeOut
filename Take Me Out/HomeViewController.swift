//
//  ViewController.swift
//  Take Me Out
//
//  Created by Daniel Barychev on 9/9/16.
//
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var takeMeOutButton: UIButton!
    @IBOutlet weak var centerButton: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    //The user settings
    var settings = Settings(restaurants: true, arts: true, fitness: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func takeMeOut(sender: UIButton) {
        centerButton.highlighted = true
        self.performSegueWithIdentifier("ShowPlace", sender: nil)
        centerButton.highlighted = false
    }
    
    // MARK: Navigation
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SettingsViewController, mySettings = sourceViewController.newSettings {
            settings = mySettings
            
            saveSettings()
        }
    }
    
    // MARK: NSCoding
    func saveSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(settings!, toFile: Settings.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Save failed")
        }
    }
}

