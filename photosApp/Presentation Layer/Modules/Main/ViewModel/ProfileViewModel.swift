//
//  ProfileViewModel.swift
//  photosApp
//
//  Created by hashem on 16/12/2021.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    //MARK:- variables
    
    ///Listen to the loading status
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    ///Listen to the network error
    var networkErrorBehavior = BehaviorRelay<String>(value: "")
    
    ///Listen to the userID value
    var userIdBehavior = BehaviorRelay<Int>(value: 1)
    
    //Encapsulating users Data
    private var usersSubject = PublishSubject<[UsersModel]>()
    //Getter

    lazy var usersDriver: Driver<[UsersModel]> = usersSubject.asDriver(onErrorJustReturn: [])
    
    //Encapsulating albums Data
    private var albumsSubject = PublishSubject<[AlbumsModel]>()
    //Getter
    lazy var albumsDriver: Driver<[AlbumsModel]> = albumsSubject.asDriver(onErrorJustReturn: [])
    
    /// network services 
    private let userProvider = MoyaProvider<UserService>()

    private let group = DispatchGroup()

    init() {
        fetchData()
    }
    
    //MARK:- requests group
    /// this function requests two APIs (users & albums) in a dispatch group
   private func fetchData(){
        group.enter()
        fetchUserData()
        
        group.enter()
        fetchAlbumData()

    }
    
    //MARK:- fetch User Data
    /// function to request users from API
   private func fetchUserData(){
        userProvider.request(.readUsers) {[weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                do{
                    let users = try JSONDecoder().decode([UsersModel].self, from: response.data)
                    self.usersSubject.onNext(users)

                } catch let jsonError{
                    self.networkErrorBehavior.accept("\(jsonError.localizedDescription)")
                }
            case .failure(let error):
                self.networkErrorBehavior.accept("\(error.localizedDescription)")
            }
        }
    }
    
    //MARK:- fetch Album Data
    /// function to request albums from API using its user id
    func fetchAlbumData(){
        loadingBehavior.accept(true)
        userProvider.request(.readAlbums(userId: userIdBehavior.value)) {[weak self] (result) in
            guard let self = self else {return}
            self.loadingBehavior.accept(false)

            switch result{
            case .success(let response):
                do{
                    let albums = try JSONDecoder().decode([AlbumsModel].self, from: response.data)
                    self.albumsSubject.onNext(albums)
                    
                } catch let jsonError{
                    self.networkErrorBehavior.accept("\(jsonError.localizedDescription)")
                }
            case .failure(let error):
                self.networkErrorBehavior.accept("\(error.localizedDescription)")
            }
        }
    }
}
