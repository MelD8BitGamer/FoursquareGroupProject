//
//  DetailView.swift
//  FoursquareGroupProject
//
//  Created by Tsering Lama on 2/26/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//
import UIKit
import DataPersistence

class detail: UIView {

    public lazy var scrollView: UIScrollView = {
        let SCV = UIScrollView()
        return SCV
    }()
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
    }()
    
    public lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "trash.fill")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    public lazy var venueName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.text = "Pursuit"
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var priceRange: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.textColor = .gray
        label.text = "$$"
        return label
    }()
    
    public lazy var venueAdress: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.textColor = .gray
        label.text = "47-10 Austell Pl"
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var days: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.textColor = .gray
        label.text = "Monday-Friday"
        return label
    }()
    
    public lazy var hours: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    public lazy var rating: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.text = "★★★"
        return label
    }()
    
    public lazy var directionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    public lazy var hyperlink: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        // create safari hyperlink to venue website.
        return label
    }()
    
    public lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Asset12"), for: .normal)
        button.addTarget(self, action: #selector(animateButtons), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        return button
    }()
    
    public lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Asset11"), for: .normal)
        button.addTarget(self, action: #selector(saveVenue), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        button.alpha = 0
        return button
    }()
    
    public lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Asset10"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        button.alpha = 0
        return button
    }()
    
    public lazy var rateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Asset9"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        button.alpha = 0
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: nil)
    
//    let dataPersistence = DataPersistence<Venue>(filename: "savedVenue.plist")
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setUpScrollView()
        setupContentView()
        setupImageView()
        setupVenueName()
        setupPriceRange()
        setupVenueAddress()
        setupDays()
        setupHours()
        setupRating()
        blurEffect()
        setupRateButton()
        setupShareButton()
        setupSaveButton()
        setupMenuButton()
        setupPopUpView()
        setupCollectionView()
    }
    
    fileprivate func blurEffect() {
        contentView.addSubview(visualEffectView)
        visualEffectView.frame = frame
        visualEffectView.isHidden = true
    }
    
    private func setUpScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: self.bounds.height),
            scrollView.widthAnchor.constraint(equalToConstant: self.bounds.width)
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
        ])
    }
    
    private func setupVenueName() {
        contentView.addSubview(venueName)
        venueName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            venueName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupPriceRange() {
        contentView.addSubview(priceRange)
        priceRange.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceRange.leadingAnchor.constraint(equalTo: venueName.trailingAnchor, constant: 3),
            priceRange.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
        ])
    }
    
    private func setupVenueAddress() {
        contentView.addSubview(venueAdress)
        venueAdress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            venueAdress.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            venueAdress.topAnchor.constraint(equalTo: venueName.bottomAnchor, constant: 20),
            venueAdress.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupDays() {
        contentView.addSubview(days)
        days.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            days.topAnchor.constraint(equalTo: venueAdress.bottomAnchor, constant: 8),
            days.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            days.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        ])
    }
    
    private func setupRating() {
        contentView.addSubview(rating)
        rating.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rating.topAnchor.constraint(equalTo: hours.bottomAnchor, constant: 20),
            rating.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            rating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupHours() {
        contentView.addSubview(hours)
        hours.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hours.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            hours.topAnchor.constraint(equalTo: days.bottomAnchor, constant: 20),
            hours.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupPopUpView() {
        contentView.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popUpView.centerXAnchor.constraint(equalTo: centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: centerYAnchor),
            popUpView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5),
            popUpView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            popUpView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1000)
        ])
    }
    
    private func setupCollectionView() {
        popUpView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: popUpView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor)
        ])
    }
    
    private func setupMenuButton() {
        addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.heightAnchor.constraint(equalToConstant: 60),
            menuButton.widthAnchor.constraint(equalToConstant: 60),
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            menuButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupSaveButton() {
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupShareButton() {
        addSubview(shareButton)
       shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.heightAnchor.constraint(equalToConstant: 60),
            shareButton.widthAnchor.constraint(equalToConstant: 60),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
   }
    
    private func setupRateButton() {
         addSubview(rateButton)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             rateButton.heightAnchor.constraint(equalToConstant: 60),
             rateButton.widthAnchor.constraint(equalToConstant: 60),
             rateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
             rateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
         ])
    }
    
    @objc private func animateButtons() {
        if saveButton.alpha == 0 && shareButton.alpha == 0 && rateButton.alpha == 0{
            visualEffectView.isHidden = false
            saveButton.alpha = 1
            shareButton.alpha = 1
            rateButton.alpha = 1
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
                self.saveButton.transform = CGAffineTransform(translationX: 0, y: -70)
                self.shareButton.transform = CGAffineTransform(translationX: 0, y: -145)
                self.rateButton.transform = CGAffineTransform(translationX: 0, y: -225)
                self.visualEffectView.effect = UIBlurEffect(style: .regular)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
                self.saveButton.transform = .identity
                self.shareButton.transform = .identity
                self.rateButton.transform = .identity
                self.visualEffectView.isHidden = true
            }, completion: nil)
            saveButton.alpha = 0
            shareButton.alpha = 0
            rateButton.alpha = 0
        }
    }
    
    @objc private func saveVenue() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.popUpView.transform = CGAffineTransform(translationX: 0, y: -900)
        }, completion: nil)
//        do {
//
//        } catch {
//
//        }
    }
}

extension UIView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let spacingBetweenItems: CGFloat = 10
        let numberOfItems: CGFloat = 1
        let itemHeight:CGFloat = maxSize.height * 0.50
        let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1 ) * spacingBetweenItems
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

