//
//  FoursquareGroupProjectTests.swift
//  FoursquareGroupProjectTests
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import XCTest
@testable import FoursquareGroupProject

class FoursquareGroupProjectTests: XCTestCase {

    func testSearch() {
        
        let expectedCount = 3
        
        FourSquareAPICLient.getResults(city: "miami", spot: "dumplings") { (result) in
            switch result {
            case .failure(let error):
                XCTFail("decoding error: \(error)")
            case .success(let venue):
                let count = venue.count
                XCTAssertEqual(expectedCount, count)
            }
        }
        
    }
}
