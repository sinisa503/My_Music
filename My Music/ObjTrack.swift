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
    
    var name: String?
    var duration:String?
    
    required init?(map: Map) {
        if map.JSON["name"] == nil || map.JSON["duration"] == nil {
            return nil
        }else {
            mapping(map: map)
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        duration <- map["duration"]
    }
}
