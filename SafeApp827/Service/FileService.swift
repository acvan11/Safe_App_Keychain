//
//  FileService.swift
//  SafeApp827
//
//  Created by mac on 9/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


class FileService {
    
    
    //MARK: Save
    class func save(data: Data, isVideo: Bool) {
        
        //documents/users/(uniqueName)
        
        //change path depending on if it is video or not
        let uniquePath = isVideo ? String(data.hashValue) + ".mov" : String(data.hashValue)
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(uniquePath)
        
        do {
            try data.write(to: url)
            CoreManager.shared.save(path: uniquePath, isVideo: isVideo)
            print("Saved Data to Disk")
        } catch {
            print("Couldn't Save to Disk")
        }
        
    }
    
    //MARK: Load
    class func load(from path: String) -> URL? {
        
        let documentDir = FileManager.SearchPathDirectory.documentDirectory
        let userDomain = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDir, userDomain, true)
        
        guard let dirPath = paths.first else { return nil }
        
        return URL(fileURLWithPath: dirPath).appendingPathComponent(path)
    }
    
    
}
