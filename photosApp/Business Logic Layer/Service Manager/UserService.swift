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
        return URL(string: "https://jsonplaceholder.typicode.com") ?? URL(string: "www.google.com")!
    }
    
    var path: String {
        switch self {
        case .readUsers:
            return "/users"
        case .readAlbums(_):
            
            return "/albums"
        case .readPhotos(_):
            return "/photos"
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
        
//        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
//        return ["Content-Type":"application/json"]
    }
    
}
