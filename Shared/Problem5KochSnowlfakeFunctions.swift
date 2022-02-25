//
//  Problem5KochSnowflakeFunctions.swift
//  Hw3BrocPashia
//
//  Created by Broc Pashia on 2/18/22.
//

import Foundation
import SwiftUI


/// makeline
///
/// Calculates the next vertex in the KochSnowflake
///
/// - Parameters:
///   - distance: distance to travel to next point
///   - angle: angle in which to travel
///   - x: x value of the current vertex
///   - y: y value of the current vetex
/// - Returns: array containing the x and y values of the new vertex
///
func makeline(distance: Double, angle: CGFloat, x: CGFloat, y: CGFloat) -> [(xPoint: Double, yPoint: Double)] {
    
    let pi = CGFloat(Float.pi)
    var newx: CGFloat
    var newy: CGFloat
    
    newx = x + CGFloat(distance) * cos(angle * pi / 180.0)
    newy = y + CGFloat(distance) * sin(angle * pi / 180.0)
    
    return([(xPoint: Double(newx), yPoint: Double(newy))])
    
}

/// turn
///
/// Calculates the turn angle in the KochSnowflake  to get the next point
///
/// - Returns: the new angle in which to progress the fractal
///
func turn (angle: CGFloat, angleChange: Double) -> CGFloat
{
    let newangle = angle + CGFloat(angleChange)
    print(String(format:"angle: %.3f  newAngle: %.3f", angle, angleChange))
    return(newangle)
}


/// KochSnowflakeCalculator
///
/// Calculates the 4 sided KochSnowflake
///
/// - Parameters:
///   - fractalnum: number of times to iterate the fractal
///   - x: x value of first vertex
///   - y: y value of first vetex
///   - size: size of the
///   - angleDivisor: integer that sets the angle as pi/piAngleDivisor so if 2, then the angle is π/2
/// - Returns: array of x and y points for all of the vertices in the KochSnowflake . Used to make the path for the view
///
func KochSnowflakeCalculator(fractalnum: Int, x: CGFloat, y: CGFloat, size: Double, angleDivisor: Double) -> [(xPoint: Double, yPoint: Double)]
{
    var allThePoints: [(xPoint: Double, yPoint: Double)] = []  ///Array of tuples
    var myX = x
    var myY = y
    
    var angle: CGFloat = 0.0
    var angleChange: CGFloat = 0.0

    allThePoints.append((xPoint: Double(x), yPoint: Double(y)))
    
    // Calculates Side 1
    angleChange = 120.0
    allThePoints += calculateKochSnowflakeSide(&angle, &angleChange, fractalnum, &myX, &myY, size, angleDivisor)
                    
    // Calculates Side 2
    angleChange = -120.0
    allThePoints += calculateKochSnowflakeSide(&angle, &angleChange, fractalnum, &myX, &myY, size, angleDivisor)
    
    // Calculates Side 3
    angleChange = -120.0
    allThePoints += calculateKochSnowflakeSide(&angle, &angleChange, fractalnum, &myX, &myY, size, angleDivisor)

//     Calculates Side 4
//    angleChange = -90.0
//    allThePoints += calculateKochSnowflakeSide(&angle, &angleChange, fractalnum, &myX, &myY, size, angleDivisor)
    
    return(allThePoints)
    
}

/// calculateKochSnowflakeSide
///
/// Calculates the KochSnowflake  from each side of the original 4 sided shape
///
/// - Parameters:
///   - angle: current angle
///   - angleChange: amount necessary to change angle to move in correct direction
///   - fractalnum: number of times to iterate the fractal
///   - myX: x value of current vertex
///   - myY: x value of current vertex
///   - size: size of the
///   - angleDivisor: integer that sets the angle as pi/piAngleDivisor so if 2, then the angle is π/2
/// - Returns: array of x and y points for all of the vertices in the KochSnowflake
///
func calculateKochSnowflakeSide(_ angle: inout CGFloat, _ angleChange: inout CGFloat, _ fractalnum: Int, _ myX: inout CGFloat, _ myY: inout CGFloat, _ size: Double, _ angleDivisor: Double) -> [(xPoint: Double, yPoint: Double)] {
    
    
    var currentPoint: [(xPoint: Double, yPoint: Double)] = []  ///Array of tuples
    ///
    angle = turn(angle: angle, angleChange: angleChange)
    currentPoint += KochSnowflakeSide(fractalnum: fractalnum, x: myX, y: myY, angle: angle, size: size, divisorForAngle: angleDivisor)
    print(String(format:"x: %.3f y: %.3f myX: %.3f myY: %.3f",myX,myY,Double(currentPoint[currentPoint.endIndex-1].xPoint), Double(currentPoint[currentPoint.endIndex-1].yPoint)))
    myX = CGFloat(currentPoint[currentPoint.endIndex-1].xPoint)
    myY = CGFloat(currentPoint[currentPoint.endIndex-1].yPoint)
    
    return ( currentPoint)
    
}


/// KochSnowflakeSide
///
/// Recursively calculates the KochSnowflake  by decrementing the fractal number\
///
/// - Parameters:
///   - fractalnum: number of times to iterate the fractal. Counts down to 0
///   - x: x value of current vertex
///   - y: y value of current vertex
///   - angle: angle needed to move to the next vertex
///   - size: size of the fractal. Recursively gets smaller.
///   - divisorForAngle: integer that sets the angle as pi/piAngleDivisor so if 2, then the angle is π/2
/// - Returns: array of x and y points for all of the vertices in the KochSnowflake 
///
func KochSnowflakeSide(fractalnum: Int, x: CGFloat, y: CGFloat, angle: CGFloat, size: Double, divisorForAngle: Double) -> [(xPoint: Double, yPoint: Double)] {
    
    var myAngle = angle
    var myX = x
    var myY = y
    let piDivisorForAngle = divisorForAngle
    var currentPoint: [(xPoint: Double, yPoint: Double)] = []  ///Array of tuples
    
    
    if(fractalnum == 0){
        currentPoint += makeline(distance: size, angle: myAngle, x: myX, y: myY)
        return(currentPoint)
    }
    else{
        
        let theta = Double.pi/Double(piDivisorForAngle)
        let thetaDeg = theta*180.0/Double.pi
        
        let newSizeOfSide = size/3.0
        
        currentPoint += KochSnowflakeSide(fractalnum: fractalnum-1, x: myX, y: myY, angle: myAngle, size: newSizeOfSide, divisorForAngle: piDivisorForAngle)
        myX = CGFloat(currentPoint[currentPoint.endIndex-1].xPoint)
        myY = CGFloat(currentPoint[currentPoint.endIndex-1].yPoint)
        
        myAngle = turn(angle: myAngle, angleChange: (120.0-thetaDeg/2.0))
        
        currentPoint += KochSnowflakeSide(fractalnum: fractalnum-1, x: myX, y: myY, angle: myAngle, size: newSizeOfSide, divisorForAngle: piDivisorForAngle)
        myX = CGFloat(currentPoint[currentPoint.endIndex-1].xPoint)
        myY = CGFloat(currentPoint[currentPoint.endIndex-1].yPoint)
        
        myAngle = turn(angle: myAngle, angleChange: -(240.0-thetaDeg))
        
        currentPoint += KochSnowflakeSide(fractalnum: fractalnum-1, x: myX, y: myY, angle: myAngle, size: newSizeOfSide, divisorForAngle: piDivisorForAngle)
        myX = CGFloat(currentPoint[currentPoint.endIndex-1].xPoint)
        myY = CGFloat(currentPoint[currentPoint.endIndex-1].yPoint)

        myAngle = turn(angle: myAngle, angleChange: (120.0-thetaDeg/2.0))

        currentPoint += KochSnowflakeSide(fractalnum: fractalnum-1, x: myX, y: myY, angle: myAngle, size: newSizeOfSide, divisorForAngle: piDivisorForAngle)
        
        
    }
    return(currentPoint)
}
