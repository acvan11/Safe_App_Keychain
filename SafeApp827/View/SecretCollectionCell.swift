//
//  SecretCollectionCell.swift
//  SafeApp827
//
//  Created by mac on 9/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SecretCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var secretThumbnail: UIImageView!
    
    var media: Media! {
        didSet {
            switch media.isVideo {
            case true:
                guard let url = FileService.load(from: media.path!) else { return }
                secretThumbnail.image = url.thumbnail
            case false:
                guard let url = FileService.load(from: media.path!) else { return }
                secretThumbnail.image = url.image
            }
        }
    }
    static let identifier = "SecretCollectionCell"
    
}
