//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/27/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit

class StudentTableViewController: UITableViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.studentLocationArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //what data does each row contain
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentRow")!
        let student = StudentInformation.studentLocationArray[indexPath.row]
        if let firstName = student.firstName {
            cell.textLabel?.text = firstName
        }
        if let lastName = student.lastName { cell.textLabel?.text = cell.textLabel?.text ?? "" + " " + lastName}
        if cell.textLabel?.text == "" { cell.textLabel?.text = "No name found"}
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    
    // MARK: Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentInformation.studentLocationArray[indexPath.row]
        guard let link = URL(string: student.mediaURL! ) else {
            return
        }
        // check to see if the url can be opened
        if  UIApplication.shared.canOpenURL(link){
            UIApplication.shared.open(link , options: [:], completionHandler: nil)
        } else {
            let alertVC = UIAlertController(title: "Invalid URL", message: "Problem with loading URL", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    @IBAction func refreshButtonTapped(_ sender: Any) {
        setUI(disabled: true)
        UdacityClient.GetStudentLocations(completion: handleStudentLocationResponse(success:studentLocations:error:))
    }
    
    func handleStudentLocationResponse(success: Bool, studentLocations: [StudentLocation], error: Error?) {
        if success && studentLocations.count > 0 {
            StudentInformation.studentLocationArray = studentLocations
            self.tableView.reloadData()
            setUI(disabled: false)
        } else {
            setUI(disabled: false)
            showAlert(message: error?.localizedDescription ?? "Error in retrieving data")
        }
    }
    
    func setUI(disabled: Bool) {
        if disabled {
            self.view.alpha = 0.75
        } else {
            self.view.alpha = 1.0
        }
        self.tableView.isUserInteractionEnabled = !disabled
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
