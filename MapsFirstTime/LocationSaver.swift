//
//  LocationSaver.swift
//  MapsFirstTime
//
//  Created by Özgür  Elmaslı on 9.03.2019.
//  Copyright © 2019 Özgür  Elmaslı. All rights reserved.
//

import Foundation
import RealmSwift

class LocationSaver : Object
{
    @objc dynamic var title : String?
    @objc dynamic var subtitle : String?
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longtitude : Double = 0.0
}
