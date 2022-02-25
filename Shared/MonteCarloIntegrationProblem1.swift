//
//  MonteCarloIntegrationProblem1.swift
//  Hw3BrocPashia
//
//  Created by Broc Pashia on 2/8/22.
//

import Foundation
import Darwin

//Class for monte carlo integration of e^-x

class MonteCarloIntegration: NSObject, ObservableObject{
    
    @MainActor @Published var dataPoints = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var calculatedIntegralResult = 0.0

// initialize class to null values
    
    @MainActor init(hasData:Bool){
        
        super.init()
        
        dataPoints = []
        calculatedIntegralResult = 0.0
        
    }
    
    // Calculate the Monte Carlo integral synchronously with a provided integer representing the "numberOfGuesses"
@MainActor func calculateMonteCarloIntegral(numberOfGuesses: Int)->Void{
    
    var results: [(xPoint:Double,yPoint:Double)] = []
    
    var randomXVal = 0.0
    var actualExponentialValue = 0.0
    let boundingBox = BoundingBox()
    
    //Create one dimensional bounding box for the integral bounds of range 0 to 1
    
    boundingBox.initWithDimensionsAndRanges(dimensions: 1, lowerBound: [0.0], upperBound: [1.0])
    
    let volume = boundingBox.volume
   
    var currentGuess = 0
    
    //Iterate throught the number of values and record the generated points on the e^-x curve with a randomly
    // generated x value in the range 0 to 1
    
    while (currentGuess<numberOfGuesses){
        randomXVal = Double.random(in: 0.0...1.0)
        actualExponentialValue = exp(-1.0 * randomXVal)
        
//        print(String(format: "xVal: %.1f, yVal: %.1f", randomXVal, actualExponentialValue))
        results.append((xPoint:randomXVal,yPoint:actualExponentialValue))

        currentGuess+=1
        
    }
    
    
    dataPoints = results
    
//Sum calculated values and find the mean
    
let mappedResults = results.map{ $0.yPoint * volume / Double(numberOfGuesses)}
 calculatedIntegralResult = mappedResults.reduce(0,+)
                                                                                           
                                                                                
}
    
    @MainActor func clear()->Void {
        dataPoints = []
        calculatedIntegralResult = 0.0
    }
}
