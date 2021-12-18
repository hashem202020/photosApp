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
    
    ///Listen to the albumID value
    var albumIdBehavior = BehaviorRelay<Int>(value: 0)
    
    lazy var albumIdObservable = albumIdBehavior.asObservable()

    //Encapsulating photos Data
    private var photosSubject = PublishSubject<[photosModel]>()
    //Getter
    lazy var photosObservable: Observable<[photosModel]> = photosSubject.asObservable()
        
    private var filteredPhotosSubject = PublishSubject<[photosModel]>()
    
    lazy var filteredPhotosObservable: Observable<[photosModel]> = filteredPhotosSubject.asObservable()
    
    
    var searchValue = BehaviorRelay<String>(value: "")
    
    lazy var searchValueObservable = searchValue.asObservable()
    
    /// network services
    private let userProvider = MoyaProvider<UserService>()
    
    let disposeBag = DisposeBag()
    
    init() {
        searchValueObservable.subscribe (onNext: { (value) in
            print("search value \(value)")
            self.photosObservable.map({$0.filter({
                if value.isEmpty{return true}
                return ($0.title?.lowercased().contains(value.lowercased()))!
            })
            
            }).bind(to: self.filteredPhotosSubject)
            .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
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
    

}
