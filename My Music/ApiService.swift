//
//  ApiService.swift
//  My Music
//
//  Created by Sinisa Vukovic on 05/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import Alamofire


class ApiService {
    
    var arrayOfAlbums:[AlbumModel] = []
    var arrayOfTracks:[TrackModel] = []
    
    func downloadTopAlbumsFor(artist: String, completed:  @escaping DownloadComplete) {
        
        let formatedArtistString = artist.replacingOccurrences(of: " ", with: "%20").lowercased()
        
        if let currentUrl = URL(string: "\(BASE_URL)\(METHOD_GET_ARTIST_TOP_ALBUMS)\(formatedArtistString)\(API_KEY)\(FORMAT_JSON)") {
            Alamofire.request(currentUrl, method: .get).responseJSON { [weak self](response) in
                if let result = response.value as? Dictionary<String,AnyObject> {
                    if let topAlbums = result["topalbums"] as? Dictionary<String, AnyObject> {
                        if let albums = topAlbums["album"] as? [Dictionary<String, AnyObject>] {
                            for album in albums {
                                
                                var albumName:String?
                                var albumImage:String?
                                var artistName:String?
                                
                                if let name = album["name"] as? String {
                                    albumName = name
                                }
                                if let images = album["image"] as? [Dictionary<String,String>] {
                                    
                                    for image in images {
                                        if let size = image["size"] {
                                            if size == "large" {
                                                let imageUrl = image["#text"]
                                                albumImage = imageUrl
                                            }
                                        }
                                    }
                                }
                                if let artist = album["artist"] as? Dictionary<String,String> {
                                    if let name = artist["name"] {
                                        artistName = name
                                    }
                                }
                                guard albumName != nil, albumImage != nil, artistName != nil else { return }
                                
                                let album = AlbumModel(albumName: albumName!, artistName: artistName!, imageUrl: albumImage!)
                                self?.arrayOfAlbums.append(album)
                                //print("Album name:\(album.name)             Artist name: \(album.artist)")
                            }
                        }
                    }
                }
                completed(true)
            }
        }else {
            completed(false)
        }
    }
    
    
    
    func downloadInfo(albumName album:String,  forArtist artist: String, completed:  @escaping InfoDownloadComplete) {
        
        let formatedArtistString = artist.replacingOccurrences(of: " ", with: "%20").lowercased()
        let formatedAlbumString = album.replacingOccurrences(of: " ", with: "%20").lowercased()
        
        let currentUrl = URL(string: "\(BASE_URL)\(METHOD_GET_ALBUM_INFO)\(API_KEY)\(PARAMETAR_ARTIST)\(formatedArtistString)\(PARAMETAR_ALBUM)\(formatedAlbumString)\(FORMAT_JSON)")
        
        Alamofire.request(currentUrl!, method: .get).responseJSON { [weak self](response) in
            var albumId:String?
                if let result = response.value as? Dictionary<String,AnyObject> {
                    if let album = result["album"] as? Dictionary<String, AnyObject> {
                        if let name = album["name"] as? String {
                            print(name)
                        }
                        if let id = album["mbid"] as? String {
                            albumId = id
                        }
                        if let tracksObject = album["tracks"] as? Dictionary<String, AnyObject> {
                            if let tracks = tracksObject["track"] as? [Dictionary<String, AnyObject>] {
                                for track in tracks {
                                    var trackName:String?
                                    var trackDuration:String?
                                    if let name = track["name"] as? String {
                                        trackName = name
                                    }
                                    if let duration = track["duration"] as? String {
                                        trackDuration = duration
                                    }
                                    guard trackName != nil, trackDuration != nil else { return }
                                    let track = TrackModel(name: trackName!, duration: trackDuration!)
                                    self?.arrayOfTracks.append(track)
                                }
                            }
                        }
                    }
                }
            completed(albumId)
        }
    }
}
