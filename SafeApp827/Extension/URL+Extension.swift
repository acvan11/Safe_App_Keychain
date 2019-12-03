//
//  URL+Extension.swift
//  SafeApp827
//
//  Created by mac on 9/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVFoundation

extension URL {
    
    
    var thumbnail: UIImage? {
        
        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(value: 2, timescale: 1) //2 seconds
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
    
    var image: UIImage? {
        guard let data = try? Data(contentsOf: self) else { return nil }
        return UIImage(data: data)
    }

}
