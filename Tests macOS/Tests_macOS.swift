//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Broc Pashia on 2/8/22.
//

import XCTest
import Hw3BrocPashia

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func calculateSphericalCoordinatesDistance(pointOne:(rVal:Double,thetaVal:Double,phiVal:Double),pointTwo:(rVal:Double,thetaVal:Double,phiVal:Double)) -> Double{
//        let r1Squared = pow(pointOne.rVal,2.0)
//        let r2Squared = pow(pointTwo.rVal,2.0)
//
//        let resultTrig = (cos(pointOne.thetaVal) * cos(pointTwo.thetaVal) * cos(pointOne.phiVal-pointTwo.phiVal) + (sin(pointOne.thetaVal) * sin(pointTwo.thetaVal)))
//        let resultR = r1Squared + r2Squared - pointOne.rVal * pointTwo.rVal * 2.0*resultTrig
        let x = pointOne.rVal*sin(pointOne.phiVal)*cos(pointOne.thetaVal)
        let xPrime = pointTwo.rVal*sin(pointTwo.phiVal)*cos(pointTwo.thetaVal)
        let y = pointOne.rVal*sin(pointOne.thetaVal)*sin(pointOne.phiVal)
        let yPrime = pointTwo.rVal*sin(pointTwo.thetaVal)*sin(pointTwo.phiVal)
        let z = pointOne.rVal*cos(pointOne.phiVal)
        let zPrime = pointTwo.rVal*cos(pointTwo.phiVal)
        
        print([x,y,z])
        print([xPrime,yPrime,zPrime])
        
        return pow((pow(xPrime-x, 2) + pow(yPrime-y, 2) + pow(zPrime-z, 2)), 0.5)
    }
    
    func testDistance() {
        
        
        
        let distance = calculateSphericalCoordinatesDistance(pointOne: (2.0, Double.pi, Double.pi/2), pointTwo: (3.0, Double.pi, Double.pi/6))
        
        XCTAssertEqual(distance, 2.645751311, accuracy: 1.0E-7, "Was not equal to this resolution.")

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
