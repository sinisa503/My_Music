//
//  TopAlbum.swift
//  My Music
//
//  Created by Sinisa Vukovic on 09/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import ObjectMapper

//Top object received by response of searching top albums
class TopAlbum: Mappable {
    private let TOP_ALBUMS = "topalbums"

    var topAlbums:ObjDict?
    
    required init?(map: Map) {
        if map.JSON[TOP_ALBUMS] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        topAlbums <- map[TOP_ALBUMS]
    }
}

class ObjDict:Mappable {
    
    private let ALBUM = "album"
    
    var albums:[ObjAlbum]?
    
    required init?(map: Map) {
        if map.JSON[ALBUM] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        albums <- map[ALBUM]
    }
}

class ObjArtist: Mappable {
    
    private let NAME = "name"
    
    var name:String?
    
    required init?(map: Map) {
        if map.JSON[NAME] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        name <- map[NAME]
    }
}

class ObjImage: Mappable {
    
    private let TEXT = "#text"
    private let SIZE = "size"
    private let LARGE = "large"
    
    var text:String?
    var size:String?
    
    required init?(map: Map) {
        if map.JSON[SIZE] == nil || map.JSON[TEXT] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        text <- map[TEXT]
        size <- map[SIZE]
    }
    
    func sizeIsLarge() -> Bool {
        if size == LARGE {
            return true
        }else {
            return false
        }
    }
}


