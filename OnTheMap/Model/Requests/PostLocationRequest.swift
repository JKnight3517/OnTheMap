//
//  PostLocationRequest.swift
//  OnTheMap
//
//  Created by Justin Knight on 4/4/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation


struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
