//
//  albumsModel.swift
//  photosApp
//
//  Created by hashem on 16/12/2021.
//

import Foundation
struct AlbumsModel : Codable {
    let userId : Int?
    let id : Int?
    let title : String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case id = "id"
        case title = "title"
    }

}
