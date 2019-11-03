

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
    @NSManaged public var uuid: Int64
    @NSManaged public var zodiacSign: String?

}
