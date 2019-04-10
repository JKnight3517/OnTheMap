//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/28/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.Logout(completion: handleLogOutResponse(success:error:))
    }
    
    func  handleLogOutResponse(success: Bool, error: Error?) {
        print("checkpoint A")
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            print("checkpoint B")
            let alertVC = UIAlertController(title: "Logout Failed", message: error?.localizedDescription , preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
}
