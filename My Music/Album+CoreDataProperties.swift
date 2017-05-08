//
//  Album+CoreDataProperties.swift
//  My Music
//
//  Created by Sinisa Vukovic on 08/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var artist: String?
    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var traks: NSSet?

}

// MARK: Generated accessors for traks
extension Album {

    @objc(addTraksObject:)
    @NSManaged public func addToTraks(_ value: Track)

    @objc(removeTraksObject:)
    @NSManaged public func removeFromTraks(_ value: Track)

    @objc(addTraks:)
    @NSManaged public func addToTraks(_ values: NSSet)

    @objc(removeTraks:)
    @NSManaged public func removeFromTraks(_ values: NSSet)

}
