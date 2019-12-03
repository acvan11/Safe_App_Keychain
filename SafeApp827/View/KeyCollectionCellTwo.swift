//
//  KeyCollectionCellTwo.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCollectionCellTwo: UICollectionViewCell {
    
    @IBOutlet weak var keyImage: UIImageView!
    
    var image: UIImage! {
        didSet {
            keyImage.image = image
        }
    }
    
    static let identifier = "KeyCollectionCellTwo"
    
}
