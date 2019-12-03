//
//  KeyCollectionCellOne.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCollectionCellOne: UICollectionViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    
    var key: String! {
        didSet {
            keyLabel.text = key
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.cellGray
            keyLabel.textColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    static let identifier = "KeyCollectionCellOne"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.frame.height / 2
    }
}
