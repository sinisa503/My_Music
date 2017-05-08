//
//  Album.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

class AlbumModel {
    
    private var _id: String? = nil
    private var _tracks: [TrackModel]? = nil
    private let _name: String
    private let  _artist: String
    private let _imageUrl: String

    init(albumName: String, artistName:String, imageUrl: String) {
        _name = albumName
        _artist = artistName
        _imageUrl = imageUrl
    }

    var id:String? {
        return _id
    }
    
    var tracks: [TrackModel]? {
        return _tracks
    }
    
    var name: String {
        return _name
    }
    
    var artist: String {
        return _artist
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    func set(tracks: [TrackModel]) {
        self._tracks = tracks
    }
    
    func set(id:String) {
        self._id = id
    }
}
