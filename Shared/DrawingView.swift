//
//  DrawingView.swift
//  Hw3BrocPashia
//
//  Created by Broc Pashia on 2/11/22.
//

import Foundation
import SwiftUI

struct drawingView: View {
    
    @Binding var redLayer : [(xPoint: Double, yPoint: Double)]
    
    var body: some View {
    
        
        ZStack{
        
            drawIntegral(drawingPoints: redLayer )
                .stroke(Color.red).frame(width: 600, height: 600)
            
        
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}

struct drawingViewOverlapIntegral: View {
    
    @Binding var redLayer : [(rPoint: Double, phiPoint: Double)]
    
    var body: some View {
    
        
        ZStack{
        
            drawOverlapIntegral(drawingPoints: redLayer )
                .stroke(Color.red)
            
        
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}

struct DrawingView_Previews: PreviewProvider {
    
    @State static var redLayer : [(xPoint: Double, yPoint: Double)] = [(0.0, 0.0), (0.0, 0.1)]
    @State static var blueLayer : [(xPoint: Double, yPoint: Double)] = [(0.0, 0.0), (0.0, 0.1)]
    
    static var previews: some View {
       
        
        drawingView(redLayer: $redLayer).frame(width: 600, height: 600)
            .aspectRatio(1, contentMode: .fill)
            //.drawingGroup()
           
    }
}

struct drawingViewShielding: View {
    
    @Binding var redLayer : [[(xValue: Double, yValue: Double)]]
    
    
    var body: some View {
    
        
        ZStack{
            drawWallAndAxis().stroke(Color.black)
            drawShielding(drawingPoints: redLayer )
                .stroke(Color.red)
            
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}



struct drawIntegral: Shape {
    
   
    let smoothness : CGFloat = 1.0
    var drawingPoints: [(xPoint: Double, yPoint: Double)]  ///Array of tuples
    
    func path(in rect: CGRect) -> Path {
        
               
        // draw from the center of our rectangle
        let scale = rect.width
        

        // Create the Path for the display
        
        var path = Path()


        for item in drawingPoints {
            print(String(format: "xVal: %.1f, yVal: %.1f", item.xPoint, item.yPoint))

            path.addRect(CGRect(x: item.xPoint*Double(scale), y: scale - item.yPoint*Double(scale) , width: 1.0 , height: 1.0))
            
        }


        return (path)
    }
}

struct drawOverlapIntegral: Shape {
    
   
    let smoothness : CGFloat = 1.0
    var drawingPoints: [(rPoint: Double, phiPoint: Double)]  ///Array of tuples
    
    func path(in rect: CGRect) -> Path {
        
               
        // draw from the center of our rectangle
        let scale = rect.width
        

        // Create the Path for the display
        
        var path = Path()


        for item in drawingPoints {
//            print(String(format: "xVal: %.1f, yVal: %.1f", item.rPoint, item.phiPoint))

            path.addRect(CGRect(x: item.rPoint*Double(scale), y: scale - item.phiPoint*Double(scale) , width: 1.0 , height: 1.0))
            
        }


        return (path)
    }
}

struct drawShielding: Shape {
    let smoothness : CGFloat = 1.0
    var drawingPoints: [[(xValue: Double, yValue: Double)]]  ///Array of tuples
  

    
    func path(in rect: CGRect) -> Path {
        
               
        // draw from the center of our rectangle
        let scale = rect.width / 7.0
        

        // Create the Path for the display
        
        var path = Path()
        print("Drawing...")

//        path.addRect(CGRect(x:1.0*Double(scale),y:0, width: 5.0*Double(scale), height:5.0*Double(scale)))
        
        for item in Array(drawingPoints.joined()) {
            path.addRect(CGRect(x: item.xValue*Double(scale)+scale, y: rect.width-(item.yValue*Double(scale)+scale), width: 1.0 , height: 1.0))
            
        }


        return (path)
    }
}
    
    struct drawWallAndAxis: Shape {
        let smoothness : CGFloat = 1.0
      

        
        func path(in rect: CGRect) -> Path {
            
                   
            // draw from the center of our rectangle
            let scale = rect.width / 7.0
            

            // Create the Path for the display
            
            var path = Path()
            

            path.addRect(CGRect(x:Double(scale),y:Double(scale), width: 5.0*Double(scale), height:5.0*Double(scale)))
            path.move(to: CGPoint(x:0,y:6.0*Double(scale)))
            path.addLine(to:CGPoint(x:rect.width,y:6.0*Double(scale)))
            


            return (path)
        }

}
