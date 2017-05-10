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
        if map.JSON["name"] == nil || map.JSON["artist"] == nil || map.JSON["image"] == nil {
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
    
    func set(tracks: [ObjTrack]) {
        self.tracks = tracks
    }
}
