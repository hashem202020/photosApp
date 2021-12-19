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
    
    //MARK:- outlets
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
    private func uiHandler(){
        title = albumName
        photosCollectionView.register(UINib(nibName: Constants.shared.photoCell, bundle: nil), forCellWithReuseIdentifier: Constants.shared.photoCell)
        
        photosCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //MARK:- fetch Photos
    ///this function fetching photos depending on it's album ID from View Model
    private func fetchPhotos(){
        albumVM.albumIdBehavior.accept(albumId ?? 0)
        albumVM.fetchPhotosData()
    }
    
    //MARK:- bind Data
    /// this unction responsiable for binding Data and updates UI Elemnts
    private func bindData(){
        photosSubscribtion()
        searchSubscribtion()
        photoSelection()
    }
    
    //MARK:- Loading control
    /// show and hide spinner by listening to the loading state from ViewModel
    private func subscribeToLoading(){
        albumVM
            .loadingBehavior
            .asDriver()
            .drive(onNext: { [weak self] (isLoading) in
            guard let self = self else {return}
            if isLoading {
                self.showSpinner()
            }else{
                self.removeSpinner()
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK:- Network errors Binding
    /// get the network error if exist
    private func subscribeToNetworkError(){
        albumVM
            .networkErrorBehavior
            .asDriver()
            .drive(onNext: { [weak self] (error) in
            guard let self = self else {return}
            if error != ""{
            self.createWarning(message: error)
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK:- photos Subscribtion
    ///this funcntion subscribes the photos filterd data and updates the collectionView
    private func photosSubscribtion() {
        albumVM
            .filteredPhotosDriver
            .drive(self.photosCollectionView.rx.items(cellIdentifier: Constants.shared.photoCell, cellType: PhotoCell.self)){row, item, cell in
                cell.photo.loadImage(URL(string: item.thumbnailUrl ?? ""))
            }.disposed(by: disposeBag)
    }
    
    //MARK:- search Subscribtion
    ///this function handels the searching Operation updating collectionView by the search result
    private func searchSubscribtion() {
        searchTextField
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: albumVM.searchValueBehavior).disposed(by: disposeBag)
    }
    
    //MARK:- photo selection
    ///this function indicate which photo has been selected then open photoViewer VC with the selected photo
    private func photoSelection(){
        photosCollectionView
            .rx
            .modelSelected(photosModel.self)
            .asDriver()
            .drive { [weak self] model in
            guard let self = self else {return}
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoViewerVC") as? photoViewerVC{
                vc.imageURL = model.url
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
                
    }
    
}

//MARK:- collection size setup
extension PhotosVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 3, height: view.bounds.height / 6)
    }
}
