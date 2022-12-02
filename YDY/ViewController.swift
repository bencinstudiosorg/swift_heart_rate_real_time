//
//  ViewController.swift
//  YDY
//
//  Created by David Spurlock on 11/21/22.
//  Copyright © 2022 GST.PID. All rights reserved.
//

import UIKit
import SwiftUI

public class HRValues{
    public static var CurrentHR = 0.0
}

@available(iOS 13.0, *)
class ViewController: UIViewController {
    @IBOutlet public weak var heartRateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIHostingController(rootView: MainSwiftUIView())
                addChild(vc)
                vc.view.frame = self.view.frame
                view.addSubview(vc.view)
                vc.didMove(toParent: self)
        
        Unity.shared.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true){ (timer) in self.updateHR(label: self.heartRateLabel) }
    }
    
    func updateHR(label: UILabel) -> Void {
        WorkoutTracking.shared.authorizeHealthKit()
        WorkoutTracking.shared.observerHeartRateSamples(thing: label)
        WatchKitConnection.shared.delegate = self
    }
}

@available(iOS 13.0, *)
extension ViewController: WatchKitConnectionDelegate {
    func didFinishedActiveSession() {
        //WatchKitConnection.shared.sendMessage(message: ["username" : "nhathm" as AnyObject])
    }
}
