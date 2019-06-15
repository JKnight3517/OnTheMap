//
//  udacityClient.swift
//  OnTheMap
//
//  Created by Justin Knight on 3/26/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import MapKit

class UdacityClient {
    
    struct GeneralInfo {
        static var session = ""
        static var appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static var restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static var userId = ""
        //keep track of if a user has posted a location before
        static var objectId = ""
        static var studentLocationArray = [StudentLocation]()
        static var savedLocation = MKPointAnnotation()
    }
    
    enum Endpoints {
        case getOrDeleteSession
        case getUserInfo(String)
        case createNewAccount
        case getLastHundredLocations
        case postUserLocation
        case updateUserLocation(String)
        
        
        var stringValue: String {
            switch self {
            case .getOrDeleteSession: return "https://onthemap-api.udacity.com/v1/session"
            case .getUserInfo(let userId): return "https://onthemap-api.udacity.com/v1/users/" + userId
            case .createNewAccount: return "https://www.udacity.com/account/auth#!/signup"
            case .getLastHundredLocations: return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100"
            case .postUserLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .updateUserLocation(let objectId): return "https://onthemap-api.udacity.com/v1/StudentLocation/" + objectId
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    
    
    class func taskForPostAction<RequestType: Encodable, ResponseType: Decodable>(URLRequest: URLRequest, body: RequestType, responseType: ResponseType.Type, udacityAction: Bool, completion: @escaping (ResponseType?, Error?)-> Void) {
        var request = URLRequest
        request.httpBody =   try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async{
                    completion(nil, error)
                }
                return
            }
            // Here we check to see if this is coming from a udacity action or not
            // If it is a udacity API action then we need to remove the first 5 characters of the response as mentioned in Udacity's API documentation
            var newData = data
            if udacityAction {
                let range = 5..<data!.count
                newData = data?.subdata(in: range)
            }
            do {
                print(String(data: newData!, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let responseObject =  try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async{
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async{ completion(nil, error)}}
        }
        task.resume()
    }
    
    class func taskForGetAction <ResponseType: Decodable>(URLRequest: URLRequest, responseType: ResponseType.Type, udacityAction: Bool, completion: @escaping (ResponseType?, Error?)-> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async{
                    completion(nil, error)
                    
                }
                return
            }
            // Here we check to see if this is coming from a udacity action or not
            // If it is a udacity API action then we need to remove the first 5 characters of the response as mentioned in Udacity's API documentation
            var newData = data
            if udacityAction {
                let range = 5..<data!.count
                newData = data?.subdata(in: range)
            }
            do {
                print(String(data: newData!, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let responseObject =  try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async{
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async{ completion(nil, error)}}
        }
        task.resume()
        
    }
    
    //MARK: Udacity APIs
    // Note that all Udacity Responses need the first 5 characters to be cut off, hence the slicing of the response
    // Login: API called to create a Udacity session when a user logs in
    // Logout: Called when a user taps the logout button on any screen that has it
    // GetUserInfo: This is an intermediary step in saving a users location - it's used to grab the user's information for the parse APIs
    
    class func Login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void) {

        var request = URLRequest(url: UdacityClient.Endpoints.getOrDeleteSession.url)

        let body = RequestSession(username: username, password: password)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        taskForPostAction(URLRequest: request, body: ["udacity":body], responseType: [String:UdacitySessionReponse].self, udacityAction: true) { (response, error) in
            if response != nil {
                print("checkpoint A")
                GeneralInfo.session = (response!["session"]?.id)!
                GeneralInfo.userId = (response!["account"]?.key)!
                completion(true,nil)
            } else {
                print("here was the error: \(error)")
                completion(false, error)
            }
        }}
    
    class func Logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: UdacityClient.Endpoints.getOrDeleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        taskForGetAction(URLRequest: request, responseType: UdacitySessionReponse.self, udacityAction: true) { (response, error) in
            if response != nil {
                GeneralInfo.session = ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func GetUserInfo(completion: @escaping(Bool,student?,Error?) -> Void) {
        let request = URLRequest(url: UdacityClient.Endpoints.getUserInfo(UdacityClient.GeneralInfo.userId).url)
        taskForGetAction(URLRequest: request, responseType: student.self, udacityAction: true) { (response, error) in
            if response != nil {
                completion(true, response, nil)
            } else {
                completion(false, nil, error)
            }
        }
    }
    
    //MARK: Parse APIs
    //  GetStudentLocations: gets the locations that initially populate the map when the user signs in
    //  PostUserLocation: saves the location a user entered to the db
    //  UpdateUserLocation: updates the location saved for a sepcific user if they've already saved an initial location ( already called PostUserLocation before)
    // SetUpParseAPIRequest: Sets up URL Requests for using Parse APIs
    
    class func GetStudentLocations(completion: @escaping(Bool, [StudentLocation], Error?) -> Void) {
        let request = setUpParseApiRequest(url:  UdacityClient.Endpoints.getLastHundredLocations.url, requestMethod: "GET")
        taskForGetAction(URLRequest: request, responseType: [String:[StudentLocation]].self, udacityAction: false) { (response, error) in
            if response != nil {
                let studentLocationArray = response!["results"]
                completion(true, studentLocationArray!, nil)
            } else {
                completion(false,[], error)
            }
        }
    }
    class func PostUserLocation(firstName: String, lastName: String, mapString: String, mediaUrl: String, lat: Double, long: Double,
                                completion: @escaping(Bool,Error?) -> Void){
        let request = setUpParseApiRequest(url: UdacityClient.Endpoints.postUserLocation.url, requestMethod: "POST")
        let body = PostLocationRequest(uniqueKey: GeneralInfo.userId, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaUrl, latitude: lat, longitude: long)
        taskForPostAction(URLRequest: request, body: body, responseType: PostLocationResponse.self, udacityAction: false) { (response, error) in
            if response != nil {
                GeneralInfo.objectId = response?.objectId ?? ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    class func UpdateUserLocation(firstName: String, lastName: String, mapString: String, mediaUrl: String, lat: Double, long: Double, completion: @escaping(Bool,Error?) -> Void){
        let request = setUpParseApiRequest(url: UdacityClient.Endpoints.updateUserLocation(GeneralInfo.objectId).url, requestMethod: "PUT")
        let body = PostLocationRequest(uniqueKey: GeneralInfo.userId, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaUrl, latitude: lat, longitude: long)
        taskForPostAction(URLRequest: request, body: body, responseType: PostLocationResponse.self, udacityAction: false) { (response, error) in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    class func setUpParseApiRequest(url: URL, requestMethod: String) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        request.addValue(UdacityClient.GeneralInfo.appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityClient.GeneralInfo.restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        if requestMethod != "GET" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    
    
}


