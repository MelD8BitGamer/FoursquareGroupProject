//
//  Extensions.swift
//  FoursquareGroupProject
//
//  Created by Howard Chang on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import Mapbox

struct Region {
    let center: CLLocationCoordinate2D
    let span: MGLCoordinateSpan
}

//extension MGLMapView {
//    var region: Region {
//        get {
//            let span = MGLCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 360.0 / pow(2.0, zoomLevel) * (frame.size.width / 256))
//            return Region(center: centerCoordinate, span: span)
//        }
//        set {
//            let zoomLevel = log2(360.0 * (frame.size.width / 256.0) / region.span.longitudeDelta)
//            setCenter(region.center, zoomLevel: zoomLevel, animated: false)
//        }
//    }
//}
