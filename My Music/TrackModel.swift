//
//  TrackModel.swift
//  My Music
//
//  Created by Sinisa Vukovic on 07/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

class TrackModel {
    
    private let _trackName: String
    private var _trackDuration: String
    
    init(name: String, duration: String) {
        self._trackName = name
        self._trackDuration = duration
    }
    
    var trackName:String {
        return _trackName
    }
    
    var trackDuration:String {
        return _trackDuration
    }
    
    func set(duration: String) {
        self._trackDuration = duration
    }
}
