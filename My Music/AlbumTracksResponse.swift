//
//  ObjTrack.swift
//  My Music
//
//  Created by Sinisa Vukovic on 10/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import ObjectMapper

//Top object received by response of searching Info about album
class ObjTopTrack : Mappable {
private let ALBUM = "album"
    var album:ObjAlbumInfo?
    
    required init?(map: Map) {
        if map.JSON[ALBUM] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        album <- map[ALBUM]
    }
}

class ObjAlbumInfo: Mappable {
    private let NAME = "name"
    private let MBID = "mbid"
    private let TRACKS = "tracks"
    
    var name: String?
    var mbid: String?
    var tracks: DictTrack?

    required init?(map: Map) {
        if map.JSON[NAME] == nil || map.JSON[MBID] == nil || map.JSON[TRACKS] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        tracks <- map[TRACKS]
        name <- map[NAME]
        mbid <- map[MBID]
    }
}

class DictTrack: Mappable {
    private let TRACK = "track"
    
    var track:[ObjTrack]?
    
    required init?(map: Map) {
        if map.JSON[TRACK] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        track <- map[TRACK]
    }
}
