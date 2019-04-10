//
//  UdacitySessionResponse.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/26/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation


struct UdacitySessionReponse: Codable {
    var registered: Bool?
    var key: String?
    var id: String?
    var expiration: String?
    var status: Int?
    var error: String?
}


extension UdacitySessionReponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
