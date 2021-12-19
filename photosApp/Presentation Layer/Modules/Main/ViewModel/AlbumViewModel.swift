//
//  AlbumViewModel.swift
//  photosApp
//
//  Created by hashem on 18/12/2021.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class AlbumViewModel{
    
    //MARK:- variables

    ///Listen to the loading status
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    ///Listen to the network error
    var networkErrorBehavior = BehaviorRelay<String>(value: "")
    
    ///Listening to the albumID value
    var albumIdBehavior = BehaviorRelay<Int>(value: 0)
    
    //listening to search value
    var searchValueBehavior = BehaviorRelay<String>(value: "")
    ///Driver trait of search value
    private lazy var searchValueDriver = searchValueBehavior.asDriver(onErrorJustReturn: "")
    
    /// `main photos` Data
    private var photosSubject = ReplaySubject<[photosModel]>.create(bufferSize: 1)
    ///`main photos` data driver
    private lazy var photosDriver: Driver<[photosModel]> = photosSubject.asDriver(onErrorJustReturn: [])

    //Encapsulating filtered photos Data
    private var filteredPhotosSubject = ReplaySubject<[photosModel]>.create(bufferSize: 1)
    ///`filtered photos` data driver
    lazy var filteredPhotosDriver: Driver<[photosModel]> = filteredPhotosSubject.asDriver(onErrorJustReturn: [])
    
    /// network services
    private let userProvider = MoyaProvider<UserService>()
    
    let disposeBag = DisposeBag()
    

    //MARK:- initializer
    init() {
        searching()
        }
    
    
    //MARK:- fetch photos Data
    /// function to request photos from API using its album Id
    func fetchPhotosData(){
        loadingBehavior.accept(true)
        userProvider.request(.readPhotos(albumsId: albumIdBehavior.value)) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                do{
                    let photos = try JSONDecoder().decode([photosModel].self, from: response.data)
                    self.photosSubject.onNext(photos)
                } catch let jsonError{
                    self.networkErrorBehavior.accept("\(jsonError.localizedDescription)")
                }
            case .failure(let error):
                self.networkErrorBehavior.accept("\(error.localizedDescription)")
            }
        }
    }
    

    //MARK:-searching
    ///this fnction handles searching ,, listening to the search value ,,filter the existed sequence and refresh the filterd sequence with result
    private func searching() {
        searchValueDriver
            .drive (onNext: {[weak self] (value) in
                guard let self = self else {return}
                self.photosDriver
                    .map({$0.filter({
                        if value.isEmpty{return true}
                        return ($0.title?.lowercased().contains(value.lowercased()))!
                    })
                    }).drive(self.filteredPhotosSubject)
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }

}
