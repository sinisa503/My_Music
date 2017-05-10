//
//  Constants.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

typealias DownloadComplete = (Bool) -> ()

struct CoreDataConstant {
    static let ALBUM_ENTITY_NAME = "Album"
    static let TRACK_ENTITY_NAME = "Track"
}

struct CellConstant {
    static let MAIN_VC_CELL = "Cell2"
    static let SEARCH_VC_CELL = "Cell"
    static let SEARCH_DETAIL_TRACKS_CELL = "TableCell"
    static let CORE_DATA_DETAIL_TABLE_CELL = "MainTableCell"
}

struct SegueiConstant {
    static let GO_TO_SEARCH_ALBUM_DETAILS = "goToAlbumDetails"
    static let SHOW_ALBUM_DETAIL_FROM_CORE_DATA = "showAlbum"
}

struct SortDescriptor {
    static let ARTIST = "artist"
}

let BASE_URL = "http://ws.audioscrobbler.com"

let METHOD_GET_ARTIST = "/2.0/?method=artist.getinfo&artist="

let METHOD_GET_ARTIST_TOP_ALBUMS = "/2.0/?method=artist.gettopalbums&artist="

let METHOD_GET_ALBUM_INFO = "/2.0/?method=album.getinfo"

let PARAMETAR_ARTIST = "&artist="

let PARAMETAR_ALBUM = "&album="

let API_KEY = "&api_key=f639f537be3377151be68a932521eca0"

let FORMAT_JSON = "&format=json"

let SHARED_SECRET = "4eb099e1bf52e7949280b3400c768f1a"
