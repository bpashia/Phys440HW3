//
//  OverlapIntegralProblem3&4.swift
//  Hw3BrocPashia
//
//  Created by Broc Pashia on 2/17/22.
//

import Foundation

 class OverlapIntegral: NSObject, ObservableObject{
    
    @MainActor @Published var dataPoints = [(rPoint:Double,phiPoint:Double)]()
    @MainActor @Published var calculatedIntegralResult = 0.0
    @MainActor let bohrRadius = 0.529177


    @MainActor init(hasData:Bool){
        
        super.init()
        
        dataPoints = []
        calculatedIntegralResult = 0.0
        
    }
    //Calculates Monte Carlo Integral for the overlap Intergral of two 1s orbitals for problem 3 and a 1s orbital and a 2px orbital for problem 4
     
     //Parameters:
     // numberOfGuesses: number of monte carlo guesses to calculate
     // problem3: boolean that tells whether or not problem 3 is currenty selected on UI
     // interatomicSpacing: a Double relating to the distance between the two orbitals. Value ranges from 0 - 10
     
    @MainActor func calculateMonteCarloIntegral(numberOfGuesses: Int, problem3:Bool, interatomicSpacing:Double)->Void{
    
    var results: [(rPoint:Double,phiPoint:Double)] = []
    let maxInteratomicSpacing = interatomicSpacing
                
    var randomXVal = 0.0
    var randomYVal = 0.0
    var randomZVal = 0.0
    var actualOrbitalValue = 0.0
    let boundingBox = BoundingBox()
        
    //Create Orbital centers based on inputted separation distance.
        
    let orbitalOneCenter = self.calculateOrbitalCenter( leftSide: true,maxInteratomicSpacing: maxInteratomicSpacing)
    let orbitalTwoCenter = self.calculateOrbitalCenter( leftSide: false, maxInteratomicSpacing: maxInteratomicSpacing)
    
    var orbitalOneDistanceToPoint = 0.0
    var orbitalTwoDistanceToPoint = 0.0
    var randomPointInPolar = (rVal: 0.0, thetaVal: 0.0, phiVal: 0.0)
        
    boundingBox.initWithDimensionsAndRanges(dimensions: 3, lowerBound: [-7.0,-7.0,-7.0], upperBound: [7.0,7.0,7.0])
    
    let volume = boundingBox.volume
   
    var currentGuess = 0
    while (currentGuess<numberOfGuesses){
        
        //Generate random point in Cartesian

        
        randomXVal = Double.random(in: -7.0...7.0)
        
        randomYVal = Double.random(in:-7.0...7.0)
        
        randomZVal =  Double.random(in:-7.0...7.0)
        
        let rTemp = pow(randomXVal*randomXVal+randomYVal*randomYVal+randomZVal*randomZVal,0.5)
        randomPointInPolar = (rVal: rTemp, thetaVal: atan(randomYVal/randomXVal) , phiVal: acos(randomZVal/rTemp))
        
        // calculate r val from center of orbital one to randomly generated point
        orbitalOneDistanceToPoint = self.calculateSphericalCoordinatesDistance(pointOne: orbitalOneCenter, pointTwo: randomPointInPolar)
        
        // calculate r val from center of orbital Two to randomly generated point

        orbitalTwoDistanceToPoint = self.calculateSphericalCoordinatesDistance(pointOne: orbitalTwoCenter, pointTwo: randomPointInPolar)
       
        // calculate polar vector from center of orbital two to randomly generated point for psi2p orbital
        
        let orbitalTwoVector = self.calculateSphericalCoordinatesVector(pointOne: orbitalTwoCenter, pointTwo: randomPointInPolar)
        
        // Problem 3: PsiS1 * PsiS1
        // Problem 4: PsiS1 * PsiP2x
        
        actualOrbitalValue = problem3 ? self.psiS1(rVal:orbitalOneDistanceToPoint) * self.psiS1(rVal:orbitalTwoDistanceToPoint) : self.psiS1(rVal:orbitalOneDistanceToPoint) * self.psiP2x(vector: orbitalTwoVector)
        
        print(String(format: "orbitalOneVal: %.15f, orbitalTwoVal: %.15f, yVal: %.15f", orbitalOneDistanceToPoint,orbitalTwoDistanceToPoint, actualOrbitalValue))
        
            results.append((rPoint:orbitalOneDistanceToPoint, phiPoint:actualOrbitalValue))


        currentGuess+=1
        
    }
    
    
    dataPoints = results
//    print(results)
    let mappedResults = results.map{ $0.phiPoint / Double(numberOfGuesses)}
    
    calculatedIntegralResult = mappedResults.reduce(0,+) * volume
                                                                                           
                                                                                
}
//psi2PX: Calculates wave function of a 1s orbital
// Parameters:
//         rVal: distance from orbital center to randomly generated point
//
//                                             - r
//                                            ----
//                                              a
//                          1                    0
//  Psi     =  -----------------------  *  e
//      s1       _________________
//              /               3
//            | /  pi  *    ( a )
//            |/               0


     
     
    func psiS1(rVal: Double)->Double{
        
        
//        let result = (1.0/(pow(Double.pi, 0.5) * pow(bohrRadius,1.5)) * exp(-1.0 * rVal / bohrRadius))
        let result = (1.0/(pow(Double.pi * pow(bohrRadius,3.0), 0.5)) * exp(-1.0 * rVal / bohrRadius))
//
        return result
        
    }
     
     // psi2PX: Calculates wave function of a 2px orbital
     // Parameters:
     //         vector: a vector in polar coordinates that points from 2px orbital center to random point
     //
     //                                             - r
     //                                            ----
     //                                             2 * a
     //                          r                       0
     //  Psi     =  -----------------------  *  e
     //      2px           _________________
     //                  /                  5
     //           4 * | /  2 * pi  *    ( a )
     //               |/                   0
     

    
    func psiP2x(vector:(rVal:Double,thetaVal:Double,phiVal:Double))->Double{
        
        let result = (vector.rVal/(4*pow(2*Double.pi * pow(bohrRadius,5.0),0.5))) * exp(-1.0 * vector.rVal / (2*bohrRadius))*sin(vector.thetaVal)*cos(vector.phiVal)
//
        return result
        
    }
    
    //calculateOrbitalCenter: returns a point on the x axis that represents the center of an orbital from the interatomic spacing
     //Parameters:
     // leftSide: Boolean that identifies whether the left orbital center or right orbital center is being calculated
     //maxInteratomicSpacing: interatomic spacing provided by user input
    func calculateOrbitalCenter(leftSide:Bool,maxInteratomicSpacing:Double)->(rVal:Double,thetaVal:Double,phiVal:Double){
        
            if (leftSide){
                return (rVal:maxInteratomicSpacing/2.0,thetaVal:Double.pi,phiVal:Double.pi/2.0)
            }
            
            return (rVal:maxInteratomicSpacing/2.0,thetaVal:0.0,phiVal:Double.pi/2.0)
            
        
        
        
    }
    
     //calculateSphericalCoordinatesDistance: convert 2 spherical points to cartesian and calculates the distance between them
     //Parameters:
     //     pointOne: point in Spherical Coords
     //     pointTwo: point in Spherical Coords
     
    func calculateSphericalCoordinatesDistance(pointOne:(rVal:Double,thetaVal:Double,phiVal:Double),pointTwo:(rVal:Double,thetaVal:Double,phiVal:Double)) -> Double{

        let x = pointOne.rVal*sin(pointOne.phiVal)*cos(pointOne.thetaVal)
        let xPrime = pointTwo.rVal*sin(pointTwo.phiVal)*cos(pointTwo.thetaVal)
        let y = pointOne.rVal*sin(pointOne.thetaVal)*sin(pointOne.phiVal)
        let yPrime = pointTwo.rVal*sin(pointTwo.thetaVal)*sin(pointTwo.phiVal)
        let z = pointOne.rVal*cos(pointOne.phiVal)
        let zPrime = pointTwo.rVal*cos(pointTwo.phiVal)
        
//        print([x,y,z])
//        print([xPrime,yPrime,zPrime])
        
        return pow((pow(xPrime-x, 2) + pow(yPrime-y, 2) + pow(zPrime-z, 2)), 0.5)
    }
    
     //Calculates a vector from one point in spherical coords to another
     //Parameters:
     //     pointOne: point in Spherical Coords
     //     pointTwo: point in Spherical Coords
     
    func calculateSphericalCoordinatesVector(pointOne:(rVal:Double,thetaVal:Double,phiVal:Double),pointTwo:(rVal:Double,thetaVal:Double,phiVal:Double)) -> (rVal:Double,thetaVal:Double,phiVal:Double){
//        let r1Squared = pow(pointOne.rVal,2.0)
//        let r2Squared = pow(pointTwo.rVal,2.0)
//
//        let resultTrig = (cos(pointOne.thetaVal) * cos(pointTwo.thetaVal) * cos(pointOne.phiVal-pointTwo.phiVal) + (sin(pointOne.thetaVal) * sin(pointTwo.thetaVal)))
//        let resultR = r1Squared + r2Squared - pointOne.rVal * pointTwo.rVal * 2.0*resultTrig
        let x = pointTwo.rVal*sin(pointTwo.phiVal)*cos(pointTwo.thetaVal)-pointOne.rVal*sin(pointOne.phiVal)*cos(pointOne.thetaVal)
        let y = pointTwo.rVal*sin(pointTwo.thetaVal)*sin(pointTwo.phiVal)-pointOne.rVal*sin(pointOne.thetaVal)*sin(pointOne.phiVal)
        let z = pointTwo.rVal*cos(pointTwo.phiVal)-pointOne.rVal*cos(pointOne.phiVal)
        
        
//        print([x,y,z])
//        print([xPrime,yPrime,zPrime])
        
        let r = pow((pow(x, 2) + pow(y, 2) + pow(z, 2)), 0.5)
        let theta = atan(pow(x*x+y*y,0.5)/z)
        let phi = atan(y/x)
        
        return (rVal:r,thetaVal:theta,phiVal:phi)
        
        
        
        
    }
    
     //Clear data for overlap Integral
    
    @MainActor func clear() -> Void {
        dataPoints = []
        calculatedIntegralResult = 0.0
    }
}
