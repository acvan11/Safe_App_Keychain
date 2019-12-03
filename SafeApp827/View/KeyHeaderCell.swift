//
//  KeyHeaderCell.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyHeaderCell: UICollectionViewCell {

    @IBOutlet weak var keyAsteriksLabel: UILabel!
    
    var asteriks: String! {
        didSet {
            keyAsteriksLabel.text = asteriks
        }
    }
    
    
    static let identifier = "KeyHeaderCell"

}
