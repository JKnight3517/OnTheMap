//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/27/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    var region = MKCoordinateRegion()
    var annotation = MKPointAnnotation()
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If the user has already entered in a location, let's load in their url so they don't have to retype it
        if StudentInformation.mediaURL != "" {
            linkTextField.text = StudentInformation.mediaURL
        }
        
    }
    
    @IBAction  func findLocation() {
        guard let searchString = locationTextField.text, let mediaURL = linkTextField.text else {
            ShowAlert(message: "You must fill out both the location and link text boxes.")
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        let activeSearch = MKLocalSearch(request: request)
        setUI(disabled: true)
        activeSearch.start { (response, error) in
            if response == nil {
                self.ShowAlert(message: "Could not find location. Please make sure your search is typed correctly.")
            } else {
                // Grab lat and longitude
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                //CLLocationDegrees is a typealias of Double so setting the doubles declared at top of class
                // Create annotation
                self.annotation = MKPointAnnotation()
                self.annotation.title = searchString
                self.annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                //zoom in on annotation
                let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
                self.region = MKCoordinateRegion(center: coordinate, span: span)
                self.setUI(disabled: false)
                self.performSegue(withIdentifier: "addLocationMap", sender: self)
            }
        }
        
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationMap" {
            let mapVC = segue.destination as! AddLocationMapViewController
            // Explicitly unwrapping the link and location text fields as they should already have been checked in findLocation
            mapVC.searchString = locationTextField.text!
            mapVC.link = linkTextField.text!
            mapVC.region = self.region
            mapVC.annotation = self.annotation
            
        }
    }

    func ShowAlert(message: String) {
        let alertVC = UIAlertController(title: "Error in finding location", message: message , preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func setUI(disabled: Bool) {
        if disabled {
            activityIndicator.startAnimating()
            self.view.alpha = 0.75
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1.0
        }
        activityIndicator.isHidden = !disabled
        locationTextField.isEnabled = !disabled
        linkTextField.isEnabled = !disabled
        findLocationButton.isEnabled = !disabled
    }
    
    
}
