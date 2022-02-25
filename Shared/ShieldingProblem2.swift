//
//  ShieldingProblem2.swift
//  Hw3BrocPashia
//
//  Created by Broc Pashia on 2/11/22.
//

import Foundation

class ShieldingNeutrons: NSObject, ObservableObject {
    @MainActor @Published var endPoints: [(xValue:Double, yValue:Double)] = []
    @MainActor @Published var paths: [[(xValue:Double, yValue:Double)]] = []
    @MainActor  var numberEscaped:Int = 0
    @MainActor @Published var percentEscaped:Double = 0.0

    
    @MainActor init(hasData: Bool){
        
        super.init()
        endPoints = []
        paths = []
    }
    
    //caluclatePath: performs a random walk for the path of a neutron in the wall until the particle leaves the wall. Adds to number of escaped if the walk exits the wall through the top, right, or bottom sides.
    //Parameters:
    //      energyConsumption: User Input that represents a percentage of energy to be consumed for every step
    //      doPaths: Boolean that says whether to store the whole path calculated (always True)

    
    @MainActor func calculatePath(energyConsumption: Int, doPaths:Bool){
        let start = (xValue:0.0, yValue:4.0)
        var energy = 100.0
        var path: [(xValue:Double, yValue:Double)] = []
        let energyConsumptionPercentage = Double(energyConsumption) * 0.01  //10%
        let energyConsumptionValuePerStep = energy * energyConsumptionPercentage
        var lastPosition = start
        var randomAngle = 0.0
        var xWalk = 0.0
        var yWalk = 0.0
        var newPos = start
        energy = energy - energyConsumptionValuePerStep

        while (energy>0){
            
            randomAngle = Double.random(in:0.0...1.0) * 2 * Double.pi
            xWalk = 1.0 * cos(randomAngle)
            yWalk = 1.0 * sin(randomAngle)
            newPos = (xValue: lastPosition.xValue + xWalk, yValue: lastPosition.yValue + yWalk)
//            print(String(format: "xVal: %.1f, yVal: %.1f", newPos.xValue,newPos.yValue))
            lastPosition = newPos
            path.append(lastPosition)
            if (newPos.xValue < 0.0 || newPos.xValue > 5.0 || newPos.yValue < 0.0 || newPos.yValue > 5.0){
                
                break
            }
            
            energy -= energyConsumptionValuePerStep
            
            
            
            
        }
        endPoints.append(lastPosition)
        if (lastPosition.xValue>5.0 || lastPosition.yValue > 5.0 || lastPosition.yValue<0.0){
            numberEscaped+=1
        }
        print(path)
        if (doPaths){
            paths.append(path)
        }
    
    }
    
    //calculateShieldingPath: calculates a provided number of random shielding paths and calculates the percentage marked as escapes
    //Parameters:
    //      numberOfPoints: number of paths to calculate
    //      energyConsumption: User Input that represents a percentage of energy to be consumed for every step
    //      doPaths: Boolean that says whether to store the whole path calculated (always True)
    
    
    @MainActor func calculateShieldingPaths(numberOfPoints: Int, energyPercentage: Int, doPaths:Bool){
        
        for _ in 1...numberOfPoints{
            calculatePath(energyConsumption:energyPercentage, doPaths:doPaths)
        }
        
        percentEscaped = Double(numberEscaped) / Double(numberOfPoints)
        
    }
    
    @MainActor func clear(){
        
        paths = []
        endPoints = []
        numberEscaped = 0
        percentEscaped = 0.0
        
    }
    
    
    
}
