//
//  ViewController.swift
//  CallKitSample
//
//  Created by Dargahwala, Huzefa on 2022-12-01.
//

import UIKit
import OSLog
import CallKit

class ViewController: UIViewController{
    
    // Ideally this object would live at app-level scope
    // For this simple example, we can keep it in this single ViewController
    var callManager: CallManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callManager = CallManager()
    }

    @IBAction func handleIncomingButtonPress(_ sender: UIButton) {
        os_log("Incmoing Call Button Pressed", type: .debug)
        callManager?.reportIncomingPhoneCall(callerName: "Jack", phoneNumber: "(123)-456-7890")
    }

    @IBAction func handleOutgoingButtonPress(_ sender: UIButton) {
        callManager?.reportOutgoingPhoneCall()
    }
}

