//
//  UserInformationRequest.swift
//  OnTheMap
//
//  Created by Justin Knight on 4/4/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation

struct student: Codable {
    let lastName: String
    let socialAccounts: [String]?
    let mailingAddress: String?
    let cohortKeys: [String]?
    let signature: String?
    let stripeCustomerId: String?
    let guardObj: guardStruct?
    let facebookId: String?
    let timezone: String?
    let sitePreferences: String?
    let occupation: String?
    let image: String?
    let firstName: String
    let jabberId: String?
    let languages: String?
    let badges: [String]?
    let location: String?
    let externalServicePassword: String?
    let principals: [String]?
    let enrollments: [String]?
    let email: Email?
    let websiteUrl: String?
    let externalAccounts: [String]?
    let bio: String?
    let coachingData: String?
    let tags: [String]?
    let affiliateProfiles: [String]?
    let hasPassword: Bool?
    let emailPreferences: EmailPreferences?
    let resume: String?
    let key: String
    let nickname: String?
    let employerSharing: Bool?
    let memberships: [Membership]?
    let zendeskId: String?
    let registered: Bool?
    let linkedinUrl: String?
    let googleId: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature = "_signature"
        case stripeCustomerId = "_stripe_customer_id"
        case guardObj = "guard"
        case facebookId = "_facebook_id"
        case timezone
        case sitePreferences = "site_preferences"
        case occupation
        case image = "_image"
        case firstName = "first_name"
        case jabberId = "jabber_id"
        case languages = "languages"
        case badges
        case location
        case externalServicePassword = "external_service_password"
        case principals = "_principals"
        case enrollments = "_enrollments"
        case email
        case websiteUrl = "website_url"
        case externalAccounts = "external_accounts"
        case bio
        case coachingData = "coaching_data"
        case tags
        case affiliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case key
        case nickname
        case employerSharing = "employer_sharing"
        case memberships
        case zendeskId = "zendesk_id"
        case registered = "_registered"
        case linkedinUrl = "linkedin_url"
        case googleId = "_google_id"
        case imageUrl = "_image_url"
       
    }
}

struct guardStruct: Codable {
    let canEdit: Bool?
    let permissions: [Permission]?
    let allowedBehaviors: [String]?
    let subjectKind: String?
    
    enum CodingKeys: String, CodingKey {
        case canEdit = "can_edit"
        case permissions
        case allowedBehaviors = "allowed_behaviors"
        case subjectKind = "subject_kind"
    }
}

struct Permission: Codable {
    let derivation: [String]?
    let behavior: String?
    let principalRef: Reference?
    
    enum CodingKeys: String, CodingKey {
        case derivation
        case behavior
        case principalRef = "principal_ref"
    }
}

struct Reference: Codable {
    let ref: String?
    let key: String?
}

struct Email: Codable {
    let verificationCodeSent: Bool?
    let verified: Bool?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case verificationCodeSent = "_verification_code_sent"
        case verified = "_verified"
        case address
    }
}

struct EmailPreferences: Codable {
    let okUserResearch: Bool?
    let masterOk: Bool?
    let okCourse: Bool?
    
    enum CodingKeys: String, CodingKey {
        case okUserResearch = "ok_user_research"
        case masterOk = "master_ok"
        case okCourse = "ok_course"
    }
}

struct Membership: Codable {
    let current: Bool?
    let groupRef: Reference?
    let creationTime: String?
    let expirationTime: String?
    
    enum CodingKeys: String, CodingKey {
        case current
        case groupRef = "group_ref"
        case creationTime = "creation_time"
        case expirationTime = "expiration_time"
    }
}
