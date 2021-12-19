//
//  photoViewerVC.swift
//  photosApp
//
//  Created by hashem on 19/12/2021.
//

import UIKit

class photoViewerVC: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullImage: UIImageView!
    
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiHandler()
        
    }
    
    //MARK:- uiHandler
    ///handels the ui elements and its states
    private func uiHandler(){
        fullImage.loadImage(URL(string: imageURL ?? ""))
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        shareImage()
    }
    
    //MARK:- share Image
    ///this unction uses UIactivityViewController to share image
    private func shareImage() {
        // image to share
        let image = fullImage.image
        
        // set up activity view controller
        let imageToShare = [ image ?? #imageLiteral(resourceName: "ReactiveExtensionsLogo") ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook , UIActivity.ActivityType.postToTwitter]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
//MARK:- zooming functions
extension photoViewerVC: UIScrollViewDelegate{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return fullImage
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImage
    }
}

