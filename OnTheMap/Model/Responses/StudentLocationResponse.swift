//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/27/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation


struct StudentLocation: Codable {
    var objectId: String
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updateAt: String?
    var ACL: String?
}
