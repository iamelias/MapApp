//
//  UserDetailResponse.swift
//  MapApp
//
//  Created by Elias Hall on 9/22/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct UserDetailResponse: Codable {
    
    let firstName: String
    let lastName: String
    
//    last_name":"Morissette"
//    social_accounts:[]
//    mailing_address:null
//    _cohort_keys:[]
//    signature:null
//    _stripe_customer_id:null
//    guard:{}
//    _facebook_id:null
//    timezone:null
//    site_preferences:null
//    occupation:null
//    _image:null
//    first_name:"Lavonne"
//    ,"jabber_id":null,"languages":null,"_badges":[],"location":null,"external_service_password":null,"_principals":[],"_enrollments":[],"email":{"address":"lavonne.morissette@onthemap.udacity.com","_verified":true,"_verification_code_sent":true},"website_url":null,"external_accounts":[],"bio":null,"coaching_data":null,"tags":[],"_affiliate_profiles":[],"_has_password":true,"email_preferences":null,"_resume":null,"key":"3903878747","nickname":"Lavonne Morissette","employer_sharing":false,"_memberships":[],"zendesk_id":null,"_registered":false,"linkedin_url":null,"_google_id":null,"_image_url":"https://robohash.org/udacity-3903878747

enum CodingKeys: String, CodingKey {
    
    case firstName = "first_name"
    case lastName = "last_name"
}
}
