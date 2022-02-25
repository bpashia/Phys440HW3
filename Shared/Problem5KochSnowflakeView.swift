//
//  Problem5KochSnowflakeView.swift
//  Hw3BrocPashia
//
//  Created by Broc Pashia on 2/18/22.
//

import Foundation
import SwiftUI

struct KochSnowflakeView: View {
    
    @Binding var kochSnowflakeVertices : [(xPoint: Double, yPoint: Double)]

    var body: some View {
        
        //Create the displayed View
        KochSnowflakeShape(KochSnowflakePoints: kochSnowflakeVertices)
            .stroke(Color.red, lineWidth: 1)
            .frame(width: 600, height: 600)
            .background(Color.white)

    }
    
    

/// KochSnowflakeShape
///
/// calculates the Shape displayed in the Koch Snowflake View
///
/// - Parameters:
///   - KochSnowflakePoints: array of tuples containing the Koch Snowflake Vertices
///
struct KochSnowflakeShape: Shape {
    
    var KochSnowflakePoints: [(xPoint: Double, yPoint: Double)] = []  ///Array of tuples
    
    
    /// path
    ///
    /// - Parameter rect: rect in which to draw the path
    /// - Returns: path for the Shape
    ///
    func path(in rect: CGRect) -> Path {
        

        // Create the Path for the Koch Snowflake
        
        
        
        var path = Path()
        
        if KochSnowflakePoints.isEmpty {
            
            return path
        }

        // move to the initial position
        path.move(to: CGPoint(x: KochSnowflakePoints[0].xPoint, y: KochSnowflakePoints[0].yPoint))

        // loop over all our points to draw create the paths
        for item in 1..<(KochSnowflakePoints.endIndex)  {
        
            path.addLine(to: CGPoint(x: KochSnowflakePoints[item].xPoint, y: KochSnowflakePoints[item].yPoint))
            
            
            }


        return (path)
        }
    }


}


struct KochSnowflakeView_Previews: PreviewProvider {
    
    @State static var myKochSnowflakeVertices = [(xPoint:75.0, yPoint:25.0), (xPoint:32.0, yPoint:22.0), (xPoint:210.0, yPoint:78.0), (xPoint:75.0, yPoint:25.0)]
    
    static var previews: some View {
    

        KochSnowflakeView(kochSnowflakeVertices: $myKochSnowflakeVertices)
        
    }
}


