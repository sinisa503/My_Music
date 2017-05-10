//
//  ObjAlbum.swift
//  My Music
//
//  Created by Sinisa Vukovic on 10/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjAlbum: Mappable {
    
    private let NAME = "name"
    private let MBID = "mbid"
    private let ARTIST = "artist"
    private let IMAGE = "image"
    
    var name: String?
    var mbid: String?
    var artist: ObjArtist?
    var tracks: [ObjTrack]?
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
        if map.JSON[NAME] == nil || map.JSON[ARTIST] == nil || map.JSON[IMAGE] == nil || map.JSON[MBID] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        name <- map[NAME]
        mbid <- map[MBID]
        artist <- map[ARTIST]
        images <- map[IMAGE]
    }
    
    func set(tracks: [ObjTrack]) {
        self.tracks = tracks
    }
}
