//
//  UserService.swift
//  photosApp
//
//  Created by hashem on 16/12/2021.
//

import Foundation
import Moya

enum UserService {
    case readUsers
    case readAlbums(userId: Int)
    case readPhotos(albumsId: Int)
}

extension UserService: TargetType{
    var baseURL: URL {
        return URL(string: Constants.shared.baseUrl) ?? URL(string: "www.google.com")!
    }
    
    var path: String {
        switch self {
        case .readUsers:
            return Constants.shared.usersPath
            
        case .readAlbums(_):
            return Constants.shared.albumsPath
            
        case .readPhotos(_):
            return Constants.shared.photosPath
                }
        }
    
    var method: Moya.Method {
        switch self{
        case .readUsers:
            return .get
        case .readAlbums(_):
            return .get
        case .readPhotos(_):
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .readUsers:
            return .requestPlain
        case .readAlbums(let userId) :
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .readPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)

        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
