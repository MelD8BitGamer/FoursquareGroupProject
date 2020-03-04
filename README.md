# FoursquareGroupProject

## Description:

Our team worked together to create mock FourSquare app allows users to search for, navigate to, save restaurants/venues/activities in different locations. (Pretty much like the actual foursquare app).

## Screenshots



## Code Snippet

Child View Controller (TableView)
``` swift
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
```

Toggle Map
``` swift
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
```

## GIF

![](FourSquareGroupProject/NewAssets/gif1.gif)

## Collaboraters 

* https://github.com/bcecilio
* https://github.com/melindadiaz
* https://github.com/tseringlamanyc
* https://github.com/howardC56
