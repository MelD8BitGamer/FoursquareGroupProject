//
//  LocationSession.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import CoreLocation


class CoreLocationSession: NSObject {
    public var locationManager: CLLocationManager
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
