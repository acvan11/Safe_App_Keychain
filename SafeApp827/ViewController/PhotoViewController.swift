//
//  PhotoViewController.swift
//  SafeApp827
//
//  Created by mac on 9/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var photoImage: UIImageView!
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhoto()
        
    }
    
    
    private func setupPhoto() {
        view.backgroundColor = .black
        photoScrollView.delegate = self
        photoScrollView.minimumZoomScale = 1
        photoScrollView.maximumZoomScale = 6
        
        guard let url = FileService.load(from: viewModel.currentMedia.path!) else { return }
        photoImage.image = url.image
        
    }


}

//UIScrollViewDelegate
extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImage
    }
    
}
