//
//  ViewController.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation

struct Location {
  let title: String
  let body: String
  let coordinate: CLLocationCoordinate2D
  let imageName: String
  
  static func getLocations() -> [Location] {
    return [
      Location(title: "Pursuit", body: "We train adults with the most need and potential to get hired in tech, advance in their careers, and become the next generation of leaders in tech.", coordinate: CLLocationCoordinate2D(latitude: 40.74296, longitude: -73.94411), imageName: "team-6-3"),
      Location(title: "Brooklyn Museum", body: "The Brooklyn Museum is an art museum located in the New York City borough of Brooklyn. At 560,000 square feet (52,000 m2), the museum is New York City's third largest in physical size and holds an art collection with roughly 1.5 million works", coordinate: CLLocationCoordinate2D(latitude: 40.6712062, longitude: -73.9658193), imageName: "brooklyn-museum"),
      Location(title: "Central Park", body: "Central Park is an urban park in Manhattan, New York City, located between the Upper West Side and the Upper East Side. It is the fifth-largest park in New York City by area, covering 843 acres (3.41 km2). Central Park is the most visited urban park in the United States, with an estimated 37.5–38 million visitors annually, as well as one of the most filmed locations in the world.", coordinate: CLLocationCoordinate2D(latitude: 40.7828647, longitude: -73.9675438), imageName: "central-park")
    ]
  }
}

class SearchViewController: UIViewController {

    var directionsRoute: Route?
    var mapView: NavigationMapView!
    var isShowingNewAnnotations = false
    var changed: Bool = false
    let url = URL(string: "mapbox://styles/howc/ck5gy6ex70k441iw1gqtnehf5")
    var annotations = [MGLPointAnnotation]()
    
    var currentCenterRegion = MGLCoordinateBounds() {
        didSet {
        }
    }
    
    private func setupMap() {
        mapView = NavigationMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        loadAnnotations()
    }
    
    func loadAnnotations() {
        let annotations = addAnnotation()
              mapView.addAnnotations(annotations)
              //mapView.showAnnotations(annotations, animated: true)
    }
    
    func addAnnotation() -> [MGLPointAnnotation] {
        var annotations = [MGLPointAnnotation]()
               for location in Location.getLocations() {
                   let annotation = MGLPointAnnotation()
                   annotation.coordinate = location.coordinate
                   annotation.title = location.title
                   annotations.append(annotation)
               }
               isShowingNewAnnotations = true
               self.annotations = annotations
        return annotations
        
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         //button.setTitle("Navigate", for: .normal)
        button.setBackgroundImage(UIImage(systemName: "car.fill"), for: .normal)
               button.setTitleColor(UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1), for: .normal)
        button.backgroundColor = .white
               button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
               button.layer.cornerRadius = 25
               button.layer.shadowOffset = CGSize(width: 0, height: 10)
               button.layer.shadowColor = UIColor.gray.cgColor
               button.layer.shadowRadius = 5
               button.layer.shadowOpacity = 0.4
        button.tag = 100
        return button
    }
    
    @objc func change(_ sender: UIButton) {
        if changed == false {
        mapView.styleURL = MGLStyle.streetsStyleURL
            changed.toggle()
        } else {
           mapView.styleURL = URL(string: "mapbox://styles/howc/ck5gy6ex70k441iw1gqtnehf5")
            changed.toggle()
        }
    }
    
    func navigate(_ to: CLLocationCoordinate2D) {
           mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
           calculateRoute(from: mapView.userLocation!.coordinate, to: to) { (route, error) in
               if error != nil {
                   print("error getting route")
               }
           }
       }

    func calculateRoute(from originCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, completion: @escaping (Route?,Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoord, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoord, coordinateAccuracy: -1, name: "Finish")
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        _ = Directions.shared.calculate(options, completionHandler: { [unowned self] (waypoints, routes, error) in
            guard let directionRoute = routes?.first else { return }
            self.directionsRoute = directionRoute
            self.drawRoute(route: directionRoute)
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoord, ne: originCoord)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
        })
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        var routeCoordinates = route.coordinates!
        let polyLine = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyLine
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyLine], options: nil)
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: UIColor.green)
            lineStyle.lineWidth = NSExpression(forConstantValue: 4.0)
            lineStyle.lineCap = NSExpression(forConstantValue: "round")
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }

}

extension SearchViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
           return true
       }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        if control.tag == 100 {
            navigate(annotation.coordinate)
        }
    }
       
//       func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//           guard let setDirection = directionsRoute else { return }
//           let navVC = NavigationViewController(for: setDirection)
//           present(navVC, animated: true)
//       }
    
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//         guard annotation is MGLPointAnnotation else {return nil}
//        let identifier = "\(annotation.coordinate.longitude)"
//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                           annotationView?.annotation = annotation
//                        return annotationView
//        }
    
 func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    if isShowingNewAnnotations {
    let annotations = addAnnotation()
    mapView.addAnnotations(annotations)
    }
    isShowingNewAnnotations = false
   }
}

