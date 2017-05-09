//
//  TopAlbum.swift
//  My Music
//
//  Created by Sinisa Vukovic on 09/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import ObjectMapper

class TopAlbum: Mappable {

    var topAlbums:ObjDict?
    
    required init?(map: Map) {
        if map.JSON["topalbums"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        topAlbums <- map["topalbums"]
    }
}

class ObjDict:Mappable {
    
    var albums:[ObjAlbum]?
    
    required init?(map: Map) {
        if map.JSON["album"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        albums <- map["album"]
    }
}

class ObjAlbum: Mappable {
    
    var name: String?
    var mbid: String?
    var artist: ObjArtist?
    private var images: [ObjImage]?
    var image:ObjImage {
        if let images = images {
            for image in images {
                if image.sizeIsLarge() {
                    return image
                }
            }
        }
        return (images?.first)!
    }
    
    required init?(map: Map) {
        if map.JSON["name"] == nil || map.JSON["artist"] == nil || map.JSON["mbid"] == nil || map.JSON["image"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        mbid <- map["mbid"]
        artist <- map["artist"]
        images <- map["image"]
    }
}

class ObjArtist: Mappable {
    
    var name:String?
    
    required init?(map: Map) {
        if map.JSON["name"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }
}

class ObjImage: Mappable {
    
    var text:String?
    var size:String?
    
    required init?(map: Map) {
        if map.JSON["size"] == nil || map.JSON["#text"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        text <- map["#text"]
        size <- map["size"]
    }
    
    func sizeIsLarge() -> Bool {
        if size == "large" {
            return true
        }else {
            return false
        }
    }
}


