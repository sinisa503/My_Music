//
//  Track+CoreDataProperties.swift
//  My Music
//
//  Created by Sinisa Vukovic on 08/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: CoreDataConstant.TRACK_ENTITY_NAME)
    }

    @NSManaged public var duration: String?
    @NSManaged public var name: String?
    @NSManaged public var album: Album?

}
