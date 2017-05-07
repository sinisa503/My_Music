//
//  Utils.swift
//  My Music
//
//  Created by Sinisa Vukovic on 07/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation

class Utils {
    static func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",  minutes, seconds)
    }
}
