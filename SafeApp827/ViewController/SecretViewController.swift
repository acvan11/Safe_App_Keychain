//
//  SecretViewController.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVKit

class SecretViewController: UIViewController {

    @IBOutlet weak var secretCollectionView: UICollectionView!
    
    
    let pickerController = UIImagePickerController()
    
    private enum MediaType: String {
        case image = "public.image"
        case video = "public.movie"
    }
    
    //let viewModel = ViewModel(manager: FakeCoreManager())
    //let vm = ViewModel(manager: CoreManager())
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSecret()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMedia()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        present(pickerController, animated: true, completion: nil)
    }
    
    
    private func setupSecret() {
        
        pickerController.delegate = self
        viewModel.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [MediaType.image.rawValue, MediaType.video.rawValue] //allow videos and images
        
    }
    
    
}
//MARK: CollectionView

extension SecretViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecretCollectionCell.identifier, for: indexPath) as! SecretCollectionCell
        cell.media = viewModel.media[indexPath.row]
        return cell
    }
    
    
    
}

extension SecretViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = viewModel.media[indexPath.row]
        viewModel.currentMedia = media
        
        switch media.isVideo {
        case true:
            guard let url = FileService.load(from: media.path!) else { return }
            let videoViewController = AVPlayerViewController()
            videoViewController.player = AVPlayer(url: url)
            present(videoViewController, animated: true) {
                videoViewController.player?.play()
            }
        case false:
            let photoVC = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
            photoVC.viewModel = viewModel
            navigationController?.pushViewController(photoVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let test = 1.5
        let variable = CGFloat(2*test)
        let width = (view.frame.width - variable) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
}



//UIImagePickerControllerDelegate & UINavigationControllerDelegate)
extension SecretViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //function that will be called after selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }

        switch mediaType {
        case MediaType.image.rawValue:
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                let data = image.jpegData(compressionQuality: 1) else { return }

        FileService.save(data: data, isVideo: false)

        case MediaType.video.rawValue:
            guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                let data = try? Data(contentsOf: url) else { return }

            FileService.save(data: data, isVideo: true)

        default:
            break
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}


extension SecretViewController: ViewModelDelegate {
    func update() {
        DispatchQueue.main.async {
            self.secretCollectionView.reloadData()
        }
    }
}
