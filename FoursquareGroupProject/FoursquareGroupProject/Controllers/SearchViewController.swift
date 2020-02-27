//
//  ViewController.swift
//  FoursquareGroupProject
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import Mapbox
import DataPersistence
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation

class SearchViewController: UIViewController {
    
    var cardViewController: TableViewController!
    var visualEffectView: UIVisualEffectView!
     
    let cardHeight:CGFloat = 700
    let cardHandleAreaHeight:CGFloat = 105
     
    var cardVisible = false
    var nextState: CardState {
      return cardVisible ? .collapsed : .expanded
    }
     
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    enum CardState {
      case expanded
      case collapsed
    }
    
    func setupCard() {
    visualEffectView = UIVisualEffectView()
    visualEffectView.frame = self.view.frame
    self.view.addSubview(visualEffectView)
     
    cardViewController = TableViewController()
    self.addChild(cardViewController)
    self.view.addSubview(cardViewController.view)
     
    cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
     
    cardViewController.view.clipsToBounds = true
     
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleCardTap(recognzier:)))
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SearchViewController.handleCardPan(recognizer:)))
      cardViewController.view.addGestureRecognizer(tapGestureRecognizer)
      cardViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
     
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
      switch recognzier.state {
      case .ended:
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
      default:
        break
      }
    }
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
      switch recognizer.state {
      case .began:
        startInteractiveTransition(state: nextState, duration: 0.9)
      case .changed:
        let translation = recognizer.translation(in: self.cardViewController.view)
        var fractionComplete = translation.y / cardHeight
        fractionComplete = cardVisible ? fractionComplete : -fractionComplete
        updateInteractiveTransition(fractionCompleted: fractionComplete)
      case .ended:
        continueInteractiveTransition()
      default:
        break
      }
    }
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
      if runningAnimations.isEmpty {
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
          switch state {
          case .expanded:
            self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
          case .collapsed:
            self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
          }
        }
        frameAnimator.addCompletion { _ in
          self.cardVisible = !self.cardVisible
          self.runningAnimations.removeAll()
        }
        frameAnimator.startAnimation()
        runningAnimations.append(frameAnimator)
        let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
          switch state {
          case .expanded:
            self.cardViewController.view.layer.cornerRadius = 20
            self.cardViewController.view.layer.masksToBounds = true
          case .collapsed:
            self.cardViewController.view.layer.cornerRadius = 20
            self.cardViewController.view.layer.masksToBounds = true
          }
        }
        cornerRadiusAnimator.startAnimation()
        runningAnimations.append(cornerRadiusAnimator)
        let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
          switch state {
          case .expanded:
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
          case .collapsed:
            self.visualEffectView.effect = nil
          }
        }
        blurAnimator.startAnimation()
        runningAnimations.append(blurAnimator)
      }
    }
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
      if runningAnimations.isEmpty {
        animateTransitionIfNeeded(state: state, duration: duration)
      }
      for animator in runningAnimations {
        animator.pauseAnimation()
        animationProgressWhenInterrupted = animator.fractionComplete
      }
    }
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
      for animator in runningAnimations {
        animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
      }
    }
    func continueInteractiveTransition (){
      for animator in runningAnimations {
        animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
      }
    }

    
    private var searchView = SearchView()
    
    private var dataPersistence: DataPersistence<Collection>
    
    var allImages = [UIImage]()
    
    init(dataPersistence: DataPersistence<Collection>) {
           self.dataPersistence = dataPersistence
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var allVenues = [Venue]() {
        didSet {
            searchView.photoCV.reloadData()
        }
    }
    
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
    
    var currentCity = "central park"
    
    private func setupMap() {
        mapView = NavigationMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        mapView.addSubview(searchView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        searchView.citySearch.delegate = self
        searchView.venueSearchTextField.delegate = self
        searchView.photoCV.register(SearchVCCell.self, forCellWithReuseIdentifier: "searchCell")
        searchView.photoCV.dataSource = self
        searchView.photoCV.delegate = self
    }
        
   func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            //button.setTitle("Navigate", for: .normal)
            button.setBackgroundImage(UIImage(named: "car"), for: .normal)
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
        
        func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            button.setBackgroundImage(UIImage(named: "walking"), for: .normal)
                   button.setTitleColor(UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1), for: .normal)
                   button.backgroundColor = .white
                   button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
                   button.layer.cornerRadius = 25
                   button.layer.shadowOffset = CGSize(width: 0, height: 10)
                   button.layer.shadowColor = UIColor.gray.cgColor
                   button.layer.shadowRadius = 5
                   button.layer.shadowOpacity = 0.4
                   button.tag = 101
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
    
    func navigate(_ to: CLLocationCoordinate2D, profileIdentifier: MBDirectionsProfileIdentifier?) {
        mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        calculateRoute(from: mapView.userLocation!.coordinate, to: to, profileIdentifire: profileIdentifier) { (route, error) in
            if error != nil {
                print("error getting route")
            }
        }
    }
    
    func calculateRoute(from originCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, profileIdentifire: MBDirectionsProfileIdentifier?, completion: @escaping (Route?,Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoord, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoord, coordinateAccuracy: -1, name: "Finish")
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: profileIdentifire)
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
    
    func getData(city: String, venue: String) {
        FourSquareAPICLient.getResults(city: city, venue: venue) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("no data: \(appError)")
            case .success(let venueData):
                DispatchQueue.main.async {
                    self?.allVenues = venueData
                    dump(venueData)
                    self?.loadVenueAnnotations()
                }
            }
        }
    }
    
    func loadVenueAnnotations() {
        let annotations = addVenueAnnotation()
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func addVenueAnnotation() -> [MGLPointAnnotation] {
        var annotations = [MGLPointAnnotation]()
        for venue in allVenues {
            let annotation = MGLPointAnnotation()
            annotation.title = venue.name
            let lat = venue.location.lat
            let long = venue.location.lng
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        //isShowingNewAnnotations = true
        self.annotations = annotations
        return annotations
        
    }
    
}

extension SearchViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
    if control.tag == 100 {
        navigate(annotation.coordinate, profileIdentifier: .automobileAvoidingTraffic)
    }
    if control.tag == 101 {
        navigate(annotation.coordinate, profileIdentifier: .walking)
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
            let annotations = addVenueAnnotation()
            mapView.addAnnotations(annotations)
        }
        isShowingNewAnnotations = false
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getData(city: currentCity, venue: searchBar.text!)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        currentCity = textField.text ?? ""
        return true
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVenues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as? SearchVCCell else {
            fatalError()
        }
        let aVenue = allVenues[indexPath.row]
        cell.configreCell(venue: aVenue)
        var cellImageArray = [UIImage]()
        cellImageArray.append(cell.imageView.image ?? UIImage(systemName: "person.fill")!)
        allImages = cellImageArray
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aVenue = allVenues[indexPath.row]
        let detailVC = DetailViewController(dataPersistence, venue: aVenue)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

