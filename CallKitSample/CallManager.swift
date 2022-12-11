//
//  CallProviderDelegate.swift
//  CallKitSample
//
//  Created by Dargahwala, Huzefa on 2022-12-02.
//

import CallKit
import OSLog

class CallManager: NSObject, CXProviderDelegate {
    
    var callProvider: CXProvider
    var ongoingCallID: UUID? = nil
    var callController: CXCallController
    
    override init() {
        
        self.callProvider = CXProvider(configuration: CXProviderConfiguration())
        self.callController = CXCallController()
        super.init()
        
        // Setting the queue to nil will result on delegate methods
        // to be called on the main queue, this is ok for this sample project.
        // As the project grows in complexity, we have to off-load a separate queue.
        self.callProvider.setDelegate(self, queue: nil)
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        os_log("Call was Answered", type: .debug)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        os_log("Call was Ended", type: .debug)
        action.fulfill()
    }
    
    // I have skipped the rest of the provider methods for brevity
    // For adding more callbacks, refer to
    // https://developer.apple.com/documentation/callkit/cxproviderdelegate
    
    func providerDidReset(_ provider: CXProvider) {
        os_log("Provider was reset", type: .debug)
        
        // We should end any in-progress calls and start with a clean slate
    }
    
    func reportIncomingPhoneCall(callerName: String,
                                 phoneNumber: String) {
        os_log("Reporting an incoming phone call", type: .debug)
        
        // Configure the call
        let update = CXCallUpdate()
        update.localizedCallerName = callerName
        update.hasVideo = false
        let callerHandle = CXHandle(type: .phoneNumber, value: phoneNumber)
        update.remoteHandle = callerHandle
        
        // Create a UUID for the call to be managed, each call should have
        // a unique ID
        let callID = UUID()
        callProvider.reportNewIncomingCall(with: callID, update: update) {err in
            if err != nil {
                os_log("Error reporting an incoming call %@",
                       type: .error,
                       String(describing: err))
                self.ongoingCallID = nil
            }
        }
        ongoingCallID = callID
    }
    
    func reportOutgoingPhoneCall() {
        os_log("Reporting OutgoingPhoneCall")
        let handle = CXHandle(type: .generic, value: "MyPhone")
        let newOutgoingCallAction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: handle))
        callController.request(newOutgoingCallAction) { err in
            if(err != nil) {
                os_log("Error handling outgoing call %@",
                       type: .error,
                String(describing: err))
            }
        }
    }
}
