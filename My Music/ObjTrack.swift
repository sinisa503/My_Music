//
//  ObjTrack.swift
//  My Music
//
//  Created by Sinisa Vukovic on 10/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjTrack: Mappable {
    
    private let NAME = "name"
    private let DURATION = "duration"
    
    var name: String?
    var duration:String?
    
    required init?(map: Map) {
        if map.JSON[NAME] == nil || map.JSON[DURATION] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        name <- map[NAME]
        duration <- map[DURATION]
    }
}
