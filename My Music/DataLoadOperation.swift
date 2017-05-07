//
//  DataLoad.swift
//  My Music
//
//  Created by Sinisa Vukovic on 06/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

class DataLoadOperation: Operation {
    var album: AlbumModel?
    var loadingCompleteHandler: ((AlbumModel) -> ())?
    
    private let _album: AlbumModel
    
    init(_ album: AlbumModel) {
        _album = album
    }
    
    override func main() {
        if isCancelled { return }
        usleep(800 * 1000)
        
        if isCancelled { return }
        self.album = _album
        
        if let loadingCompleteHandler = loadingCompleteHandler {
            DispatchQueue.main.async {
                loadingCompleteHandler(self._album)
            }
        }
    }

}
