//
//  MainController.swift
//  YDY WatchKit Extension
//

import WatchKit
import HealthKit

class MainController: WKInterfaceController {
    @IBOutlet weak var userNameLabel: WKInterfaceLabel!
    @IBOutlet weak var stepCountsLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    @IBOutlet weak var button1: WKInterfaceButton!
    
    var isStarted: Bool = false//not yet connected
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        print("AWAKE")
        
//        WorkoutTracking.shared.startWorkOut()
        WorkoutTracking.shared.delegate = self
        button1.setBackgroundColor(UIColor(red: 214/255.0, green:46/255.0, blue:219/255.0, alpha: 1.0 ))
//
        WatchKitConnection.shared.delegate = self
        WatchKitConnection.shared.startSession()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("WILL ACTIVE")
        WorkoutTracking.shared.fetchStepCounts()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("DID DEACTIVE")
    }
}

extension MainController {
    @IBAction func startWorkout() {
        
        if(isStarted){
            stopRoutine()
        } else{
            startRoutine()
        }
        
        //startRoutine()
    }
    
    @IBAction func stopWorkout() {
        stopRoutine()
    }
    
    func startRoutine(){
        WorkoutTracking.authorizeHealthKit()
        WorkoutTracking.shared.startWorkOut()
        userNameLabel.setText("Started Workout")
        heartRateLabel.setText("Getting HR...")
        button1.setTitle("Stop")
        isStarted = true
    }
    
    func stopRoutine(){
        WorkoutTracking.shared.stopWorkOut()
        userNameLabel.setText("Stopped Workout")
        heartRateLabel.setText("")
        stepCountsLabel.setText("")
        button1.setTitle("Start")
        isStarted = false
    }
    
    
}

extension MainController: WorkoutTrackingDelegate {
    func enableBackgroundDelivery(for type: HKObjectType, frequency: HKUpdateFrequency, withCompletion completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    func didReceiveHealthKitHeartRate(_ heartRate: Double) {
        heartRateLabel.setText("\(heartRate) BPM")
        WatchKitConnection.shared.sendMessage(message: ["heartRate":
            "\(heartRate)" as AnyObject])
    }
    
    func didReceiveHealthKitStepCounts(_ stepCounts: Double) {
        stepCountsLabel.setText("\(stepCounts) STEPS")
    }
}

extension MainController: WatchKitConnectionDelegate {
    func didReceiveUserName(_ userName: String) {
        userNameLabel.setText(userName)
    }
}
