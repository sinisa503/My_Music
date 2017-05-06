//
//  Album.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

class Album {
    
    private let _name: String
    private let  _artist: String
    private let _imageUrl: String

    init(albumName: String, artistName:String, imageUrl: String) {
        _name = albumName
        _artist = artistName
        _imageUrl = imageUrl
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
    
}
