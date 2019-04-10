//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/27/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import MapKit


class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    var searchString = ""
    var link = ""
    var annotation = MKPointAnnotation()
    var region = MKCoordinateRegion()
    var firstName = ""
    var lastName = ""
    var alreadyPostedLocationMessage = "You have already posted a location, are you sure you would like to override it?"
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    
    
    @IBAction func postLocationButtonTapped(_ sender: Any) {
        if UdacityClient.GeneralInfo.objectId != "" {
            showPostLocationFailure(message: alreadyPostedLocationMessage)
        }
        else {
            UdacityClient.GetUserInfo(completion: handleUserInfoResponse(success:student:error:))
        }
    }
    
    func handleUserInfoResponse(success: Bool, student: student?, error: Error?) {
        if success {
            firstName =  student!.firstName
            lastName = student!.lastName
            if UdacityClient.GeneralInfo.objectId != "" {
                UdacityClient.UpdateUserLocation(firstName: firstName , lastName: lastName , mapString: searchString, mediaUrl: link, lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude, completion: handlePostLocationResponse)
            }
            else {
                UdacityClient.PostUserLocation(firstName: firstName , lastName: lastName , mapString: searchString, mediaUrl: link, lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude, completion: handlePostLocationResponse)
            }
        }
        else {
          showPostLocationFailure(message: error?.localizedDescription ?? "Error in retrieving user information from udacity")
        }
    }
    
    func handlePostLocationResponse (success: Bool, error: Error?) {
        
        if success {
            // Save the location to display on the map and then transition back to the general map
            let SavedAnnotation = annotation
            SavedAnnotation.title = "\(firstName) \(lastName)"
            SavedAnnotation.subtitle = link
            StudentInformation.savedLocation = SavedAnnotation
            StudentInformation.mediaURL = link
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is MapViewController {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
        else {
            showPostLocationFailure(message: error?.localizedDescription ?? "Error in saving location to server")
        }
    }
    
    func showPostLocationFailure(message: String) {
        // Check to see if we're alerting user if they've already posted a location vs another error
        if message == alreadyPostedLocationMessage {
            let alertVC = UIAlertController(title: "Location Already Posted", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Override", style: .destructive, handler: { (action) in
                UdacityClient.GetUserInfo(completion: self.handleUserInfoResponse(success:student:error:))
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "Location Failed to Save", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    
}
