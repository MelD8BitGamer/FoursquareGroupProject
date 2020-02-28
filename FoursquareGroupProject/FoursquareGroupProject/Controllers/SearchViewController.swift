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
    
    var navigateButton: UIButton!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
       }

    public lazy var photoCV: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width / 3, height: view.frame.height / 10)
          let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
          cv.backgroundColor = .clear
          return cv
       }()
    
    private func setupCV() {
        mapView.addSubview(photoCV)
           photoCV.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            photoCV.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            photoCV.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            photoCV.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            photoCV.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.10)
           ])
       }
    
   var venueSearchTextField: UITextField!
    private func configTextField() {
        venueSearchTextField = UITextField(frame: CGRect(x: 15, y: 100, width: view.bounds.width - 30, height: 50))
        venueSearchTextField.backgroundColor = UIColor.gray
               venueSearchTextField.placeholder = "  Search for city"
               venueSearchTextField.layer.cornerRadius = 9
        venueSearchTextField.setLeftPadding(10)
        venueSearchTextField.setRightPadding(10)
        mapView.addSubview(venueSearchTextField)
    }
    
    var citySearch: UISearchBar!
    private func configSearchBar() {
        citySearch = UISearchBar(frame: CGRect(x: 15, y: 50, width: view.bounds.width - 30, height: 50))
        citySearch.backgroundImage = UIImage()
        citySearch.backgroundColor = UIColor.gray
        citySearch.layer.cornerRadius = 9
        citySearch.placeholder = "Search for venue"
        mapView.addSubview(citySearch)
    }
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
        visualEffectView.isUserInteractionEnabled = false
        self.view.addSubview(visualEffectView)
        
        cardViewController = TableViewController(dataPersistence)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.handleCardTap(recognzier:)))
        //tapGestureRecognizer.cancelsTouchesInView = false
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
                    self.mapView.isUserInteractionEnabled = false
                case .collapsed:
                    self.mapView.isUserInteractionEnabled = true
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
            if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {

                source.shape = nil
            }
            navigateButton.isHidden = true
            photoCV.reloadData()
            cardViewController.venues = allVenues
        }
    }
    
    var directionsRoute: Route?
    var mapView: NavigationMapView!
    var isShowingNewAnnotations = false
    var changed: Bool = false
    let url = URL(string: "mapbox://styles/howc/ck5gy6ex70k441iw1gqtnehf5")
    var annotations = [MGLPointAnnotation]()
    
    var currentCity = "central park"
    
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
        configSearchBar()
        configTextField()
        setupCV()
        citySearch.delegate = self
        venueSearchTextField.delegate = self
        photoCV.register(SearchVCCell.self, forCellWithReuseIdentifier: "searchCell")
        photoCV.dataSource = self
        photoCV.delegate = self
        setupCard()
        configChangeMapButton()
        zoomToUser()
        navigateVC()
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.setTitleColor(UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1), for: .normal)
        button.backgroundColor = .white
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
    
    private func navigateVC() {
              navigateButton = UIButton(frame: CGRect(x: 350, y: 440, width: 50, height: 50))
              //zoomToUserButton.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
        navigateButton.setTitle("GO", for: .normal)
        navigateButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
              navigateButton.layer.cornerRadius = 25
              navigateButton.layer.masksToBounds = true
        navigateButton.setTitleColor(UIColor.black, for: .normal)
              //navigateButton.tintColor = .blue
              navigateButton.backgroundColor = .green
              navigateButton.layer.shadowOffset = CGSize(width: 0, height: 10)
              navigateButton.layer.shadowColor = UIColor.gray.cgColor
              navigateButton.layer.shadowRadius = 5
              navigateButton.layer.shadowOpacity = 0.4
              navigateButton.addTarget(self, action: #selector(startNavigation(_:)), for: .touchUpInside)
        navigateButton.isHidden = true
              mapView.addSubview(navigateButton)
          }
    
    @objc func startNavigation(_ sender: UIButton) {
        guard let setDirection = directionsRoute else { return }
                 let navVC = NavigationViewController(for: setDirection)
                  present(navVC, animated: true)
    }
    
    private func zoomToUser() {
           let zoomToUserButton = UIButton(frame: CGRect(x: 350, y: 520, width: 50, height: 50))
           //zoomToUserButton.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
        zoomToUserButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
           zoomToUserButton.layer.cornerRadius = 25
           zoomToUserButton.layer.masksToBounds = true
           zoomToUserButton.tintColor = .blue
           zoomToUserButton.backgroundColor = .white
           zoomToUserButton.layer.shadowOffset = CGSize(width: 0, height: 10)
           zoomToUserButton.layer.shadowColor = UIColor.gray.cgColor
           zoomToUserButton.layer.shadowRadius = 5
           zoomToUserButton.layer.shadowOpacity = 0.4
           zoomToUserButton.addTarget(self, action: #selector(getCurrentUserLocation(_:)), for: .touchUpInside)
           mapView.addSubview(zoomToUserButton)
       }
    
    @objc func getCurrentUserLocation(_ sender: UIButton) {
        mapView.userTrackingMode = .follow
    }
    
    private func configChangeMapButton() {
        let changeMapStyleButton = UIButton(frame: CGRect(x: 350, y: 590, width: 50, height: 50))
        changeMapStyleButton.setBackgroundImage(UIImage(named: "changeMap"), for: .normal)
        changeMapStyleButton.layer.cornerRadius = 15
        changeMapStyleButton.layer.masksToBounds = true
        changeMapStyleButton.tintColor = .black
        changeMapStyleButton.backgroundColor = .green
        changeMapStyleButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        changeMapStyleButton.layer.shadowColor = UIColor.gray.cgColor
        changeMapStyleButton.layer.shadowRadius = 5
        changeMapStyleButton.layer.shadowOpacity = 0.4
        changeMapStyleButton.addTarget(self, action: #selector(change(_:)), for: .touchUpInside)
        mapView.addSubview(changeMapStyleButton)
    }
    
    @objc func change(_ sender: UIButton) {
        navigateButton.isHidden = true
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
        calculateRoute(from: mapView.userLocation!.coordinate, to: to, profileIdentifier: profileIdentifier) { (route, error) in
            if error != nil {
                print("error getting route")
            }
        }
    }
    
    func calculateRoute(from originCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, profileIdentifier: MBDirectionsProfileIdentifier?, completion: @escaping (Route?,Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoord, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoord, coordinateAccuracy: -1, name: "Finish")
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: profileIdentifier)
        _ = Directions.shared.calculate(options, completionHandler: { [unowned self] (waypoints, routes, error) in
            guard let directionRoute = routes?.first else { return }
            self.directionsRoute = directionRoute
            self.drawRoute(route: directionRoute)
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoord, ne: originCoord)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
            self.navigateButton.isHidden = false
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
        annotations.removeAll()
        if let mapAnnotations = mapView.annotations {
            mapView.removeAnnotations(mapAnnotations)
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

extension SearchViewController: MGLMapViewDelegate {
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
        present(detailVC, animated: true, completion: nil)
    }
}

