//
//  Favorites+CoreDataProperties.swift
//  TheCatApp
//
//  Created by revangelista on 07/05/2024.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var idx: [NSString]

}

extension Favorites : Identifiable {

}
