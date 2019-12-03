//
//  ViewController+Extension.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


extension KeyViewController {
    
    
    func goToSecret() {
        DispatchQueue.main.async {
            let secretNC = self.storyboard?.instantiateViewController(withIdentifier: "SecretNavigation") as! UINavigationController
            self.present(secretNC, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
