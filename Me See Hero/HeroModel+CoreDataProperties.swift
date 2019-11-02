//
//  HeroModel+CoreDataProperties.swift
//  Me See Hero
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 ydu1717. All rights reserved.
//
//

import Foundation
import CoreData


extension HeroModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeroModel> {
        return NSFetchRequest<HeroModel>(entityName: "HeroModel")
    }

    @NSManaged public var cityofresidence: String?
    @NSManaged public var image: NSData?
    @NSManaged public var locationtitle: String?
    @NSManaged public var name: String?
    @NSManaged public var snapshot: NSData?
    @NSManaged public var uuid: UUID?
    @NSManaged public var zodiacSign: String?

}
