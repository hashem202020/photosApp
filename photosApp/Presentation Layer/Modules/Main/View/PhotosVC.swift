//
//  PhotosVC.swift
//  photosApp
//
//  Created by hashem on 18/12/2021.
//

import UIKit
import RxSwift
import Kingfisher

class PhotosVC: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    let albumVM = AlbumViewModel()
    let disposeBag = DisposeBag()
    
    var albumId:Int?
    var albumName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiHandler()
        fetchPhotos()
        bindData()
    }
    
    //MARK:- uiHandler
    ///handels the ui elements and its states
    func uiHandler(){
        title = albumName
        photosCollectionView.register(UINib(nibName: Constants.shared.photoCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.photoCell)
        
        photosCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //MARK:- fetch Photos
    ///this function fetching photos depending on it's album ID from View Model
    func fetchPhotos(){
        albumVM.albumIdBehavior.accept(albumId ?? 0)
        albumVM.fetchPhotosData()
    }
    
    //MARK:- bind Data
    /// this unction responsiable for binding Data and updates UI Elemnts
    func bindData(){

        albumVM
            .filteredPhotosObservable
            .observe(on: MainScheduler.instance)
            .catchAndReturn([])
            .bind(to: self.photosCollectionView.rx.items(cellIdentifier: Constants.shared.photoCell, cellType: PhotoCell.self)){row, item, cell in
                cell.photo.loadImage(URL(string: item.thumbnailUrl ?? ""))
            }.disposed(by: disposeBag )
        

        searchTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: albumVM.searchValue).disposed(by: disposeBag)
        photosCollectionView.reloadData()
    }

}


extension PhotosVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 3, height: view.bounds.height / 6)
    }
}
