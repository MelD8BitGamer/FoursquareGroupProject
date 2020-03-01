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

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private var cardViewController: TableViewController!
    private var visualEffectView: UIVisualEffectView!
    private var allItems = [Item]()
    private let cardHandleAreaHeight:CGFloat = 105
   private var cardVisible = false
   private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
   private var runningAnimations = [UIViewPropertyAnimator]()
   private var animationProgressWhenInterrupted:CGFloat = 0
   private enum CardState {
        case expanded
        case collapsed
    }
    
   private func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        visualEffectView.isUserInteractionEnabled = false
        self.view.addSubview(visualEffectView)
        
        cardViewController = TableViewController(dataPersistence)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
    cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: (view.frame.height / 4) * 3.5)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SearchViewController.handleCardPan(recognizer:)))
        cardViewController.venueTableView.topView.addGestureRecognizer(tapGestureRecognizer)
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
            var fractionComplete = translation.y / (view.frame.height / 4) * 3.5
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    private func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - (self.view.frame.height / 4) * 3.5
                    self.searchView.mapView.isUserInteractionEnabled = false
                case .collapsed:
                    self.searchView.mapView.isUserInteractionEnabled = true
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
    
   private func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
   private func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
   private func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    private var dataPersistence: DataPersistence<Collection>
    
    //    var allImages = [UIImage]() {
    //        didSet {
    //            cardViewController.allImages = allImages
    //        }
    //    }
    
    init(dataPersistence: DataPersistence<Collection>) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var allVenues = [Venue]() {
        didSet {
            if let source = searchView.mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
                
                source.shape = nil
            }
            searchView.navigateVC.isHidden = true
            searchView.photoCV.reloadData()
            cardViewController.venues = allVenues
            //cardViewController.allImages = allImages
        }
    }
    
   private var directionsRoute: Route?
    //var isShowingNewAnnotations = false
   private var changed: Bool = false
    //let url = URL(string: "mapbox://styles/howc/ck5gy6ex70k441iw1gqtnehf5")
   private var annotations = [MGLPointAnnotation]()
   private var currentCity = "central park"
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.mapView.delegate = self
        searchView.venueSearch.delegate = self
        searchView.citySearch.delegate = self
        searchView.photoCV.register(SearchVCCell.self, forCellWithReuseIdentifier: "searchCell")
        searchView.photoCV.dataSource = self
        searchView.photoCV.delegate = self
        setupCard()
        searchView.navigateVC.addTarget(self, action: #selector(startNavigation(_:)), for: .touchUpInside)
        searchView.zoomToUser.addTarget(self, action: #selector(getCurrentUserLocation(_:)), for: .touchUpInside)
        searchView.changeMapButton.addTarget(self, action: #selector(change(_:)), for: .touchUpInside)
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.setTitleColor(UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 0, height: 40)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.4
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
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
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        button.tag = 101
        return button
    }
    
    @objc func startNavigation(_ sender: UIButton) {
        view.animateButtonView(sender)
        guard let setDirection = directionsRoute else { return }
        let navVC = NavigationViewController(for: setDirection)
        present(navVC, animated: true)
    }

    @objc func getCurrentUserLocation(_ sender: UIButton) {
        view.animateButtonView(sender)
        searchView.mapView.userTrackingMode = .follow
    }
    
    @objc func change(_ sender: UIButton) {
        view.animateButtonView(sender)
        searchView.navigateVC.isHidden = true
        if changed == false {
            searchView.mapView.styleURL = MGLStyle.streetsStyleURL
            changed.toggle()
        } else {
            searchView.mapView.styleURL = searchView.url
            changed.toggle()
        }
    }
    
   private func navigate(_ to: CLLocationCoordinate2D, profileIdentifier: MBDirectionsProfileIdentifier?) {
        searchView.mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        calculateRoute(from: searchView.mapView.userLocation!.coordinate, to: to, profileIdentifier: profileIdentifier) { (route, error) in
            if error != nil {
                print("error getting route")
            }
        }
    }
    
   private func calculateRoute(from originCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, profileIdentifier: MBDirectionsProfileIdentifier?, completion: @escaping (Route?,Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoord, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoord, coordinateAccuracy: -1, name: "Finish")
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: profileIdentifier)
        _ = Directions.shared.calculate(options, completionHandler: { [unowned self] (waypoints, routes, error) in
            guard let directionRoute = routes?.first else { return }
            self.directionsRoute = directionRoute
            self.drawRoute(route: directionRoute)
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoord, ne: originCoord)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.searchView.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.searchView.mapView.setCamera(routeCam, animated: true)
            self.searchView.navigateVC.isHidden = false
        })
        
    }
    
   private func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        var routeCoordinates = route.coordinates!
        let polyLine = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        if let source = searchView.mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyLine
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyLine], options: nil)
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: UIColor.green)
            lineStyle.lineWidth = NSExpression(forConstantValue: 4.0)
            lineStyle.lineCap = NSExpression(forConstantValue: "round")
            searchView.mapView.style?.addSource(source)
            searchView.mapView.style?.addLayer(lineStyle)
        }
    }
    
   private func getData(city: String, venue: String) {
        FourSquareAPICLient.getResults(city: city, venue: venue) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    print("no data: \(appError)")
                    self?.showAlert(title: "No results", message: "Please check your searches")
                }
            case .success(let venueData):
                DispatchQueue.main.async {
                    if venueData.count == 0 {
                        self?.showAlert(title: "No results", message: "Please check your searches")
                    }
                    self?.allVenues = venueData
                    dump(venueData)
                    self?.loadVenueAnnotations()
                }
            }
        }
    }
    
   private func loadVenueAnnotations() {
        let annotations = addVenueAnnotation()
        searchView.mapView.addAnnotations(annotations)
        searchView.mapView.showAnnotations(annotations, animated: true)
    }
    
   private func addVenueAnnotation() -> [MGLPointAnnotation] {
        annotations.removeAll()
        if let mapAnnotations = searchView.mapView.annotations {
            searchView.mapView.removeAnnotations(mapAnnotations)
        }
        var getAnnotations = [MGLPointAnnotation]()
        for venue in allVenues {
            let annotation = MGLPointAnnotation()
            annotation.title = venue.name
            let lat = venue.location.lat
            let long = venue.location.lng
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.coordinate = coordinate
            getAnnotations.append(annotation)
        }
        self.annotations = getAnnotations
        return annotations
    }
    
}

extension SearchViewController: MGLMapViewDelegate, NavigationViewControllerDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        if control.tag == 100 {
            navigate(annotation.coordinate, profileIdentifier: .automobileAvoidingTraffic)
        } else if control.tag == 101 {
            navigate(annotation.coordinate, profileIdentifier: .walking)
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
            let annotations = addVenueAnnotation()
            searchView.mapView.addAnnotations(annotations)
        }
 
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getData(city: currentCity, venue: searchBar.text!)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentCity = textField.text ?? "New York"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        currentCity = textField.text ?? "New York"
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
        //cellImageArray.append(cell.imageView.image ?? UIImage(systemName: "person.fill")!)
        //cellImageArray = allImages
        cell.backgroundColor = .clear
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aVenue = allVenues[indexPath.row]
        let detailVC = DetailViewController(dataPersistence, venue: aVenue)
        present(detailVC, animated: true, completion: nil)
    }
}

