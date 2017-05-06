//
//  AlbumRealm.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumRealm: Object {
    
    dynamic var albumId = NSUUID().uuidString
    
    dynamic var albumName = ""
    dynamic var artist = ""
    dynamic var image = NSData()
    
    convenience init(albumName:String, albumArtist:String, image: NSData) {
        self.init()
        self.albumName = albumName
        self.artist = albumArtist
        self.image = image
    }
    
    override class func primaryKey() -> String? {
        return "albumId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["image"]
    }
}
