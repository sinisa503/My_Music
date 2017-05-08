//
//  Constants.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

let BASE_URL = "http://ws.audioscrobbler.com"

let METHOD_GET_ARTIST = "/2.0/?method=artist.getinfo&artist="

let METHOD_GET_ARTIST_TOP_ALBUMS = "/2.0/?method=artist.gettopalbums&artist="

let METHOD_GET_ALBUM_INFO = "/2.0/?method=album.getinfo"

let PARAMETAR_ARTIST = "&artist="

let PARAMETAR_ALBUM = "&album="

let API_KEY = "&api_key=f639f537be3377151be68a932521eca0"

let FORMAT_JSON = "&format=json"

let SHARED_SECRET = "4eb099e1bf52e7949280b3400c768f1a"

let TEST_REQUEST_ALBUMS_CHER = "http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=cher&api_key=f639f537be3377151be68a932521eca0&format=json"

let TEST_REQUEST_ALBUM_CHER = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key= f639f537be3377151be68a932521eca0&artist=Cher&album=Believe&format=json"

typealias DownloadComplete = () -> ()
typealias InfoDownloadComplete = (String?) -> ()

struct CoreDataConstant {
    static let ALBUM_ENTITY_NAME = "Album"
}
