//
//  ObjTrack.swift
//  My Music
//
//  Created by Sinisa Vukovic on 10/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjTopTrack : Mappable {

    var album:ObjAlbumInfo?
    
    required init?(map: Map) {
        if map.JSON["album"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        album <- map["album"]
    }
}

class ObjAlbumInfo: Mappable {
    
    var name: String?
    var mbid: String?
    var tracks: DictTrack?

    required init?(map: Map) {
        if map.JSON["name"] == nil || map.JSON["mbid"] == nil || map.JSON["tracks"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        tracks <- map["tracks"]
        name <- map["name"]
        mbid <- map["mbid"]
    }
}

class DictTrack: Mappable {
    
    var track:[ObjTrack]?
    
    required init?(map: Map) {
        if map.JSON["track"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        track <- map["track"]
    }
}
