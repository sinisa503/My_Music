//
//  Album+Functions.swift
//  My Music
//
//  Created by Sinisa Vukovic on 07/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

extension Album {
    
    static func addNewAlbumToDatabase(albumModel:AlbumModel,with image: NSData,context:NSManagedObjectContext, saved: (Bool) -> ()) {
        
        let request = NSFetchRequest<Album>(entityName: CoreDataConstant.ALBUM_ENTITY_NAME)
        
        if let id = albumModel.id {
            request.predicate = NSPredicate(format: "id = %@", id)
        }else {
            request.predicate = NSPredicate(format: "name = %@", albumModel.name)
        }
        
        do {
            let albums = try context.fetch(request)
            if albums.count > 0 {
                return
            }else {
                if let newAlbum = NSEntityDescription.insertNewObject(forEntityName: CoreDataConstant.ALBUM_ENTITY_NAME, into: context) as? Album{
                    newAlbum.id = albumModel.id
                    newAlbum.artist = albumModel.artist
                    newAlbum.name = albumModel.name
                    if let tracks = albumModel.tracks {
                        for track in tracks {
                            Track.createNewTrack(track: track, for: newAlbum, context: context)
                        }
                    }
                    newAlbum.image = image
                }
                do {
                    try context.save()
                    saved(true)
                } catch let error {
                    saved(false)
                    print("Error saveing Album \(error.localizedDescription)")
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

