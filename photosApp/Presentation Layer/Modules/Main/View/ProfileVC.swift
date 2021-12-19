//
//  ViewController.swift
//  photosApp
//
//  Created by hashem on 15/12/2021.
//

import UIKit
import Moya
import RxSwift

class ProfileVC: UIViewController {
    //MARK:- outlets
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var usersPickerView: UIPickerView!
    @IBOutlet weak var userControlView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    
    let profileVM = ProfileViewModel()
    let disposeBag = DisposeBag()
    
    var userId = 1
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiHandler()
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- Buttons
    @IBAction func showUsersListButtonPressed(_ sender: Any) {
        self.userControlView.isHidden = false
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        userControlView.isHidden = true
        profileVM.fetchAlbumData()
        }
    
    //MARK:- uiHandler
    ///handels the ui elements and its states
   private func uiHandler(){
        albumsTableView.register(UINib(nibName: Constants.shared.albumCell, bundle: nil), forCellReuseIdentifier: Constants.shared.albumCell)
        pickerButton.isEnabled = false
        userControlView.isHidden = true
    }
    
    //MARK:- bind Data
    /// binding Data and updates UI Elemnts
    private func bindData(){
        subscribeToLoading()
        subscribeToNetworkError()
        usersSelection()
        usersSubscribtion()
        albumsSelection()
        albumsSubscribtion()
    }
    
    //MARK:- Loading control
    /// show and hide spinner by listening to the loading state from ViewModel
    private func subscribeToLoading(){
        profileVM
            .loadingBehavior
            .asDriver()
            .drive(onNext: { (isLoading) in
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
        profileVM
            .networkErrorBehavior
            .asDriver()
            .drive(onNext: { (error) in
            if error != ""{
            self.createWarning(message: error)
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK:-usersSelection
    /// this function subscribes which user has been choosen from the picker view and updates the UI elements
    private func usersSelection(){
        usersPickerView
            .rx
            .modelSelected(UsersModel.self)
            .asDriver()
            .drive{[weak self] user in
            guard let self = self else {return}
            self.userId = user[0].id ?? 0
            self.nameLabel.text = user[0].name ?? ""
            self.addressLabel.text = "\(user[0].address?.city ?? "") \(user[0].address?.suite ?? "") \(user[0].address?.street ?? "")"
            
            self.profileVM.userIdBehavior.accept(self.userId)
        }.disposed(by: disposeBag)
    }
    
    //MARK:- user subscribtion
    ///this funcntion subscribes the users data and updates the pickerView
    private func usersSubscribtion(){
        profileVM
            .usersDriver
            .asDriver()
            .drive(self.usersPickerView.rx.itemTitles){[weak self] row, element in
                if element.id == 1{
                    self?.nameLabel.text = element.name
                    self?.addressLabel.text = "\(element.address?.city ?? "") \(element.address?.suite ?? "") \(element.address?.street ?? "")"
                    self?.pickerButton.isEnabled = true
                }
            return element.name
        }.disposed(by: disposeBag)
    }
    
    //MARK:-albums selection
    /// this function subscribes which album has been choosen from the table view and navigate to the photosVC
    private func albumsSelection(){
        albumsTableView
            .rx
            .modelSelected(AlbumsModel.self)
            .asDriver()
            .drive{[weak self] result in
            guard let self = self else {return}
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.shared.photosVC) as? PhotosVC{
                vc.albumId = result.id
                vc.albumName = result.title
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
        
    }
    
    //MARK:- albums subscribtion
    ///this funcntion subscribes the albums data and updates the tableview
    private func albumsSubscribtion(){
        profileVM
            .albumsDriver
            .asDriver()
            .drive(self.albumsTableView.rx.items(cellIdentifier: Constants.shared.albumCell, cellType: AlbumsCell.self)){row, item , cell in
            cell.albumLabel.text = item.title
        }.disposed(by: disposeBag)
    }
}


