//
//  File.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/27/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate{
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentLocation]()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.GetStudentLocations(completion: handleStudentLocationResponse(success:studentLocations:error:))
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView =  UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
   
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func handleStudentLocationResponse(success: Bool, studentLocations: [StudentLocation], error: Error?) {
        if success && studentLocations.count > 0 {
            //save the studentLocation array to our baseTabBar so it can be user across tabs
            StudentInformation.studentLocationArray = studentLocations
            locations = studentLocations
            var annotations = [MKPointAnnotation]()
            for student in locations {
                let lat = CLLocationDegrees(student.latitude ?? 0.0)
                let long = CLLocationDegrees(student.longitude ?? 0.0)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = student.firstName
                let last = student.lastName
                let mediaURL = student.mediaURL

                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first ?? "") \(last ?? "")"
                annotation.subtitle = mediaURL
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            if StudentInformation.savedLocation.title != "" {
                annotations.append(StudentInformation.savedLocation)
            }
            self.mapView.addAnnotations(annotations)
            setUI(disabled: false)
        } else {
            setUI(disabled: false)
           showAlert(message: error?.localizedDescription ?? "Error in retrieving data")
        }
        
    }
    @IBAction func refreshButtonTap(_ sender: Any) {
         setUI(disabled: true)
         UdacityClient.GetStudentLocations(completion: handleStudentLocationResponse(success:studentLocations:error:))
        
    }
    // Control when the map view and other components are disabled
    func setUI (disabled: Bool){
        if disabled {
            activityIndicator.startAnimating()
            self.view.alpha = 0.75
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1.0
        }
        activityIndicator.isHidden = !disabled
        mapView.isUserInteractionEnabled = !disabled
        logoutButton.isEnabled = !disabled
        refreshButton.isEnabled = !disabled
        addButton.isEnabled = !disabled
    }
    
    func showAlert(message: String){
        let alertVC = UIAlertController(title: "Failed to load location data", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    
}
