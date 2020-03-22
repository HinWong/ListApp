//
//  Item+Convenience.swift
//  Assessment2
//
//  Created by Hin Wong on 3/6/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    @discardableResult
    convenience init(name:String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.name = name
        self.isComplete = isComplete
    }
}
