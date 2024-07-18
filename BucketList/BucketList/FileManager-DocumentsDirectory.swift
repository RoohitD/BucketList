//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Rohit Deshmukh on 22/08/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
