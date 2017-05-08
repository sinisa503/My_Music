//
//  Track+Functions.swift
//  My Music
//
//  Created by Sinisa Vukovic on 08/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

extension Track {
    
    static func createNewTrack(track: TrackModel, for album:Album, context: NSManagedObjectContext) {
        
        if let newTrack = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as? Track{
            newTrack.name = track.trackName
            newTrack.album = album
            newTrack.duration = track.trackDuration
            try? context.save()
        }
    }
}
