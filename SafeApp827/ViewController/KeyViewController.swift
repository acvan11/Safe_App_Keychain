//
//  ViewController.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import LocalAuthentication

class KeyViewController: UIViewController {
    
    @IBOutlet weak var keyCollectionView: UICollectionView!
    
    private let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    private let images = [#imageLiteral(resourceName: "fid"), #imageLiteral(resourceName: "done"), #imageLiteral(resourceName: "backspace")]
    
    var isFirstTime: Bool {
        return UserDefaults.standard.value(forKey: "FirstTime") == nil
    }
    
    private enum CellTypes: Int {
        case Auth = 0
        case Enter = 1
        case Backspace = 2
    }
    
    var selectedNumbers = String() {
        didSet {
            DispatchQueue.main.async {
                self.keyCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKey()
    }
    
    private func setupKey() {
        //register collection view header
        keyCollectionView.register(UINib(nibName: KeyHeaderCell.identifier, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: KeyHeaderCell.identifier)
        
    }
    
    private func authenticate() {
        
        //context - to use Local Auth
        let context = LAContext()
        
        //check if device, is capable of using biometrics AND is activated
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return
        }
        
        let reason = "Use BioMetrics to continue"
        
        //evaluate their biometrics
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, err in
            if let error = err {
                print("Couldn't Authenticate: \(error.localizedDescription)")
                return
            }
            
            if success {
                self.goToSecret()
            }
        }
    }
    
}


extension KeyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? keys.count : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCollectionCellOne.identifier, for: indexPath) as! KeyCollectionCellOne
            cell.key = keys[indexPath.row]
            
            if selectedNumbers.count < 4 {
                cell.isUserInteractionEnabled = true
                cell.backgroundColor = UIColor.cellGray
            } else {
                cell.backgroundColor = UIColor.cellRed
                cell.isUserInteractionEnabled = false
            }
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCollectionCellTwo.identifier, for: indexPath) as! KeyCollectionCellTwo
            cell.image = images[indexPath.row]
            return cell
        }
    }
    
    //Renders Header for CollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KeyHeaderCell.identifier, for: indexPath) as! KeyHeaderCell
        header.keyAsteriksLabel.text = String(repeating: "*", count: selectedNumbers.count)
        return header
    }
    
}

extension KeyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let key = keys[indexPath.row]
            selectedNumbers.append(key)
        default:
            switch indexPath.row {
            case CellTypes.Auth.rawValue:
                
                authenticate()
                
            case CellTypes.Enter.rawValue:
                
                guard selectedNumbers.count == 4 else {
                    showAlert(title: "Insufficient Passcode", message: "Not enough numbers selected")
                    return
                }
                
                if isFirstTime {
                    
                    let item = KeychainItem(account: "user") //normally by email/username
                    item.save(password: selectedNumbers)
                    UserDefaults.standard.set(false, forKey: "FirstTime")
                    goToSecret()
                    
                } else {
                    
                    let item = KeychainItem(account: "user")
                    switch item.validate(pass: selectedNumbers) {
                    case true:
                        goToSecret()
                    case false:
                        showAlert(title: "Wrong Passcode", message: "Try again..")
                    }
                }
                
            case CellTypes.Backspace.rawValue:
                guard !selectedNumbers.isEmpty else { return }
                selectedNumbers.removeLast()
            default:
                break
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = view.frame.height * 0.15
        return section == 0 ? CGSize(width: view.frame.width, height: height) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 80) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30)
    }
    
    
    
}
