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
    
    var arrayOfAlbums:[Album] = []
    
    func downloadTopAlbumsFor(artist: String, completed:  @escaping DownloadComplete) {
        
        let formatedArtistString = artist.replacingOccurrences(of: " ", with: "&").lowercased()
        
        let currentUrl = URL(string: "\(BASE_URL)\(METHOD_GET_ARTIST_TOP_ALBUMS)\(formatedArtistString)\(API_KEY)\(FORMAT_JSON)")
        
        Alamofire.request(currentUrl!, method: .get).responseJSON { [weak self](response) in
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
                                if let imageUrl = images.first?["#text"] {
                                    albumImage = imageUrl
                                }
                            }
                            if let artist = album["artist"] as? Dictionary<String,String> {
                                if let name = artist["name"] {
                                    artistName = name
                                }
                            }
                            guard albumName != nil, albumImage != nil, artistName != nil else { return }
                            
                            let album = Album(albumName: albumName!, artistName: artistName!, imageUrl: albumImage!)
                            self?.arrayOfAlbums.append(album)
                            print("Album name:\(album.name)             Artist name: \(album.artist)")
                        }
                    }
                }
            }
            completed()
        }
    }
}
