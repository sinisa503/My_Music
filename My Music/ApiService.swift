//
//  ApiService.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


class ApiService {
    
    var arrayOfAlbums:[ObjAlbum] = []
    var arrayOfTracks:[ObjTrack] = []
    
    //Mapping JSON objects for top albums request
    func downloadTopAlbumsFor(artist: String, completed:  @escaping DownloadComplete) {
        let formatedArtistString = artist.replacingOccurrences(of: " ", with: "%20").lowercased()
        if let currentUrl = URL(string: "\(BASE_URL)\(METHOD_GET_ARTIST_TOP_ALBUMS)\(formatedArtistString)\(API_KEY)\(FORMAT_JSON)") {
            Alamofire.request(currentUrl).responseObject(completionHandler: {[weak self] (response: DataResponse<TopAlbum>) in
                if let topAlbum = response.result.value {
                    if let obj = topAlbum.topAlbums {
                        if let albums = obj.albums {
                            for album in albums {
                                self?.arrayOfAlbums.append(album)
                            }
                        }
                    }
                    completed(true)
                }else {
                    completed(false)
                }
            })
        }
    }
    
    //Mapping JSON objects for album tracks request
    func downloadInfo(albumName album:String,  forArtist artist: String, completed:  @escaping DownloadComplete) {
        let formatedArtistString = artist.replacingOccurrences(of: " ", with: "%20").lowercased()
        let formatedAlbumString = album.replacingOccurrences(of: " ", with: "%20").lowercased()
        if let currentUrl = URL(string: "\(BASE_URL)\(METHOD_GET_ALBUM_INFO)\(API_KEY)\(PARAMETAR_ARTIST)\(formatedArtistString)\(PARAMETAR_ALBUM)\(formatedAlbumString)\(FORMAT_JSON)") {
            Alamofire.request(currentUrl, method: .get).responseObject(completionHandler: { [weak self] (response: DataResponse<ObjTopTrack>) in
                if let topTrackObj = response.result.value {
                    if let album = topTrackObj.album {
                        for track in (album.tracks?.track)! {
                            self?.arrayOfTracks.append(track)
                        }
                    }
                    completed(true)
                }else {
                    completed(false)
                }
            })
        }
    }
}
