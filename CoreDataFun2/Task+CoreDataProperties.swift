//
//  Task+CoreDataProperties.swift
//  CoreDataFun2
//
//  Created by Valeriy Kovalevskiy on 8/3/20.
//  Copyright © 2020 Valeriy Kovalevskiy. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var describe: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var color: NSObject?
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?

}
