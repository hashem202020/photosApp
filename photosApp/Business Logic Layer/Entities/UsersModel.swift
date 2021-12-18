//
//  UsersModel.swift
//  photosApp
//
//  Created by hashem on 16/12/2021.
//

import Foundation
struct UsersModel : Codable {
    let id : Int?
    let name : String?
    let username : String?
    let email : String?
    let address : Address?
    let phone : String?
    let website : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case address = "address"
        case phone = "phone"
        case website = "website"
    }
    struct Address : Codable {
        let street : String?
        let suite : String?
        let city : String?
        let zipcode : String?

        enum CodingKeys: String, CodingKey {

            case street = "street"
            case suite = "suite"
            case city = "city"
            case zipcode = "zipcode"
        }

    }

}
