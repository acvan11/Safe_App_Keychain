//
//  ViewModel.swift
//  SafeApp827
//
//  Created by mac on 9/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func update()
}

class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    var media = [Media]() {
        didSet {
            delegate?.update()
        }
    }
    
    var currentMedia: Media!
    
    /*
    var coreManager: CoreProtocol!
    init(manager: CoreProtocol) {
        coreManager = manager
    }
    */
    
    
    func getMedia() {
        media = CoreManager.shared.load()
    }
    
    
    
}
