//
//  ContentView.swift
//  Shared
//
//  Created by Broc Pashia on 2/8/22.
//

import SwiftUI

@MainActor struct ContentView: View {

    @State var guessStringMonteCarlo = "20"
    @State var guessStringShielding = "20"
    @State var guessStringOverlapIntegral = "20"
    @State var energyAbsorbtionString = "10"
    @State var interatomicSpacing = "1"
    @State var problem4 = false
    @State var selectedProblem = 1
    @State private var totalIterations: Int? = 10
    @State private var kochSnowflakeAngle: Double? = 1.5
    @State var editedTotalIterations: Int? = 3
        
    private var intFormatter: NumberFormatter = {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            return f
        }()
    

   @ObservedObject var monteCarlo = MonteCarloIntegration(hasData:true)
   @ObservedObject var neutronShielding = ShieldingNeutrons(hasData:true)
    @ObservedObject var overlapIntegral = OverlapIntegral(hasData:true)
   @ObservedObject var kochSnowflake = KochSnowflake(withData: true)

    
    var body: some View {
        VStack(alignment: .center) {
        HStack{
            Button("Problem 1", action: {Task.init{await self.setSelectedProblem(selected: 1)}})
            Button("Problem 2", action: {Task.init{await self.setSelectedProblem(selected: 2)}})
            Button("Problem 3", action: {Task.init{await self.setSelectedProblem(selected: 3)}})
            Button("Problem 5", action: {Task.init{await self.setSelectedProblem(selected: 4)}})

        }.padding(EdgeInsets(top: 50, leading: 0, bottom: 20, trailing: 0))
            Text(String(selectedProblem==1 ? "Problem 1" : selectedProblem==2 ? "Problem 2" : selectedProblem==3 ? "Problems 3 & 4" : "Problem 5"))
                .font(.system(.largeTitle))
                .bold()
        }
        if (selectedProblem==1){
        VStack(alignment: .center) {
            HStack(alignment:.center){
            VStack(alignment: .center) {

            Text("Guesses")
                .font(.callout)
                .bold()
            
            TextField("# Guesses", text: $guessStringMonteCarlo)
                .padding()
            }
                VStack(alignment: .center) {

                Text("Calculated Result")
                    .font(.callout)
                    .bold()
                    Text(String(format: "%.4f", monteCarlo.calculatedIntegralResult))
                        .font(.callout)
                        .bold()

                }}
            
            Button("Run Calculation", action: {self.calculateMonteCarlo()})
            
            Button("Clear", action: {self.clearMonteCarlo()})
        .padding(.top, 5.0)
        
            drawingView(redLayer:$monteCarlo.dataPoints)
            .padding()
            .aspectRatio(1, contentMode: .fit)
            .drawingGroup()
                   }
        }
        if (selectedProblem==2){
            
        VStack(alignment: .center) {
            HStack(alignment: .center){
                VStack(alignment: .center) {
            Text("Particles")
                .font(.callout)
                .bold()
            TextField("# of Particles", text: $guessStringShielding)
                .padding()
            }
                VStack(alignment: .center) {
            Text("Energy Absorbtion Percentage")
                .font(.callout)
                .bold()
            TextField("Please Enter an Integer from 1 - 100", text: $energyAbsorbtionString)
                .padding()
            }
                VStack(alignment: .center) {
                Text("Percent Escaped")
                    .font(.callout)
                    .bold()
                Text(String(100 * neutronShielding.percentEscaped)+"%")
                    .font(.callout)
                    .bold()
                }
            }
          
            Button("Send Beam", action: {self.calculateNeutronShielding()})
            
            Button("Clear", action: {self.clearNeutronShielding()})
        .padding(.top, 5.0)
        
            drawingViewShielding(redLayer: $neutronShielding.paths)
            .padding()
            .aspectRatio(1, contentMode: .fit)
            .drawingGroup()
            
                   }
        }
        
        if (selectedProblem==3){
        VStack(alignment: .center) {
            HStack(alignment:.center){
            VStack(alignment: .center) {

            Text("Guesses")
                .font(.callout)
                .bold()
            
            TextField("# Guesses", text: $guessStringOverlapIntegral)
                .padding()
            }
                }
            
            VStack(alignment: .center) {

            Text("Interatomic Spacing R (0.0 - 10.0)")
                .font(.callout)
                .bold()
                TextField("R", text: $interatomicSpacing)
                    .padding()

            }
            
            HStack(alignment:.center){
                Button("Toggle Problem 3/4", action: {toggleProblem4Button()})
                Text(problem4 ? "Problem 4 is Currently Selected" : "Problem 3 is Currently Selected")
                    .font(.callout)
                    .bold()
            }
            VStack(alignment: .center) {

            Text("Calculated Result")
                .font(.callout)
                .bold()
                Text(String(format: "%.8f", overlapIntegral.calculatedIntegralResult))
                    .font(.callout)
                    .bold()

            }
            
            
            Button("Run Calculation", action: { self.calculateOverlapIntegral()})
            
            Button("Clear", action: {self.clearOverlapIntegral()})
        .padding(.top, 5.0)
        
//
                   }
        }
        if (selectedProblem==4){
            HStack{
                
                VStack{
                    
                    VStack(alignment: .center) {
                        HStack{

                            Text(verbatim: "Iterations:")
                            .padding()
                            TextField("Number of Iterations (must be between 0 and 7 inclusive)", value: $editedTotalIterations, formatter: intFormatter, onCommit: {
                                self.totalIterations = self.editedTotalIterations
                            })

                                .padding()

                            }

                    }
                    .padding(.top, 5.0)

                    
                    
                    Button("Run", action: {Task.init{
                        
                        print("Start time \(Date())\n")
                        await self.calculateKochSnowflake()}})
                        .padding()
                        .frame(width: 100.0)
                        .disabled(kochSnowflake.enableButton == false)
                    
                    Button("Clear", action: {Task.init{
                        
                        await self.clearKochSnowflake()}})
                        .padding(.bottom, 5.0)
                        .disabled(kochSnowflake.enableButton == false)
                    
                    if (!kochSnowflake.enableButton){
                        
                        ProgressView()
                    }
                    
                    
                }
                .padding()
                
                //DrawingField
                
                HStack{
                    
                    KochSnowflakeView(kochSnowflakeVertices: $kochSnowflake.kochSnowflakeVerticesForPath)
                        .padding()
                        .aspectRatio(1, contentMode: .fit)
                        .drawingGroup()
                    // Stop the window shrinking to zero.
                    Spacer()
                }
            }
        }
    }
    
    
    //Switch the UI to show a new problem solution
    
    func setSelectedProblem(selected: Int) async{
        await clearAll()
        selectedProblem = selected
    }
    
    func toggleProblem4Button(){
        problem4 = !problem4
    }
    
    // Calculate the monte carlo integration for problem one using the inputed number of guesses
    
    func calculateMonteCarlo()  {
        let guessNumber = Int(guessStringMonteCarlo)!
        monteCarlo.calculateMonteCarloIntegral(numberOfGuesses: guessNumber)
        
    }
    
    //Clear the result from problem one and set the guess string back to default
    
    func clearMonteCarlo(){
        guessStringMonteCarlo = "20"
        monteCarlo.dataPoints = []
        monteCarlo.calculatedIntegralResult = 0.0
    }
    
    // Calculate the overlap integral for problem one using the inputed number of guesses using threaded code

    
    func calculateOverlapIntegral()  {
        let guessNumber = Int(guessStringOverlapIntegral)!
        let interatomicSpacing = Double(interatomicSpacing)!
        let problem3 = !problem4
        
        let numberOfThreads = ProcessInfo.processInfo.processorCount
        
        let guessesPerThread = Int(floor(Double(guessNumber)/Double(numberOfThreads)))
        
        let lastThreadGuesses = Int(guessesPerThread) + guessNumber % Int(guessesPerThread)
        
        

                
                
                Task{
                    
                    let result:Double = await withTaskGroup(of: (Int,Double).self, /* this is the return from the taskGroup*/
                                                              returning: Double.self, /* this is the return from the result collation */
                                                              body: { taskGroup in  /*This is the body of the task*/
                        // We can use `taskGroup` to spawn child tasks here.
                        for i in stride(from: 0, to: numberOfThreads, by: 1){
                            
                            taskGroup.addTask {
                                //Create a new instance of the ValentineHeart object so that each has it's own calculating function to avoid potential issues with reentrancy problem
                                
                                let overlapIntegralThread = await OverlapIntegral(hasData:true)
                                

                                await overlapIntegralThread.calculateMonteCarloIntegral(numberOfGuesses: i == numberOfThreads-1 ? lastThreadGuesses:guessesPerThread, problem3: problem3, interatomicSpacing: interatomicSpacing)
                                
                                let singleResult = await overlapIntegralThread.calculatedIntegralResult
                                
                                
                                
                                return (i, singleResult)  /* this is the return from the taskGroup*/
                                
                            }
                            
                            
                        }
                        
//                        // Collate the results of all child tasks
                        var combinedTaskResults :[Double] = []
                        for await result in taskGroup {

                            combinedTaskResults.append(result.1)
                        }
                        let integralVal = combinedTaskResults.reduce(0,+)/Double(combinedTaskResults.count)
                        return integralVal
//
//                        return combinedTaskResults  /* this is the return from the result collation */
//
//                    })

       
                    })
                    overlapIntegral.calculatedIntegralResult = result

                }

    }
    
    //Clear the result from problem three and four and set the guess string back to default

    
    func clearOverlapIntegral(){
        guessStringOverlapIntegral = "20"
        overlapIntegral.dataPoints = []
        overlapIntegral.calculatedIntegralResult = 0.0
        problem4 = false
        interatomicSpacing = "1"
    }
    
    // Calculate the neutron shielding for problem one using the inputed number of guesses and the inputed aborbtion percentage

    
    func calculateNeutronShielding()  {
        neutronShielding.clear()
        let guessNumber = Int(guessStringShielding)!
        let guessAbsorbtion = Int(energyAbsorbtionString)!
        print("Calling calculateNeutronShielding")
        neutronShielding.calculateShieldingPaths(numberOfPoints: guessNumber, energyPercentage: guessAbsorbtion, doPaths: true)
        
        
    }
    
    //Clear the result from problem two and set the guess string back to default

    
    func clearNeutronShielding(){
        guessStringShielding = "20"
        neutronShielding.paths = []
        neutronShielding.endPoints = []
        neutronShielding.numberEscaped = 0
        neutronShielding.percentEscaped = 0.0
    }
    
    // Calculate the Koch Snowflak for problem one using the inputed number of iterations

    
    func calculateKochSnowflake() async {
        

        kochSnowflake.setButtonEnable(state: false)
        
            
            let _ = await withTaskGroup(of:  Void.self) { taskGroup in
                
            
                taskGroup.addTask(priority: .high){
                
                
                    await kochSnowflake.calculateKochSnowflake(iterations: editedTotalIterations, piAngleDivisor: kochSnowflakeAngle)
                    
                
            }
                

        
    }

        
        kochSnowflake.setButtonEnable(state: true)
        
        print("End Time of \(Date())\n")
        
    }
    
    //Clear the result from problem five and set the guess string back to default

    
    func clearKochSnowflake() async{
        
        kochSnowflake.eraseData()
        
    }
    
    func clearAll() async {
        clearMonteCarlo()
        clearNeutronShielding()
        clearOverlapIntegral()
        await clearKochSnowflake()
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
