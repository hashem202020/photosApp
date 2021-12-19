//
//  Extensions.swift
//  photosApp
//
//  Created by hashem on 16/12/2021.
//

import UIKit
import Kingfisher

fileprivate var aView: UIView?
extension UIViewController{
    //MARK:- spinner
    /// this function showing a spinner on the screen 
    func showSpinner(){
         aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        aView?.tag = 100
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    /// this function removes  the spinner on the screen
    func removeSpinner(){
        if let removeView = self.view.viewWithTag(100){
            removeView.removeFromSuperview()
//        aView = nil
        
        }
    }
    
    //MARK:- create Warning
    /// this function creates a warning with an (ok) button
    /// - Parameter message: the warning Body
    func createWarning(message: String){
        let alert  = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- UIImageView exs -----
extension UIImageView{
    /// this function loads the image from url using kingfiher pod
    /// - Parameter url: the image url to convret to image
  func loadImage(_ url : URL?) {
    self.kf.setImage(
      with: url,
      options: [
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
    self.kf.indicatorType = .activity
  }
}
