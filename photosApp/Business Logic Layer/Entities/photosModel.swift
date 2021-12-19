//
//  photosModel.swift
//  photosApp
//
//  Created by hashem on 18/12/2021.
//

import Foundation
struct photosModel : Codable {
    let albumId : Int?
    let id : Int?
    let title : String?
    let url : String?
    let thumbnailUrl : String?

    enum CodingKeys: String, CodingKey {

        case albumId = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailUrl = "thumbnailUrl"
    }
}
