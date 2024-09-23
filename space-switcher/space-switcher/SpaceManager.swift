//
//  SpaceChangeMonitor.swift
//  space-switcher
//
//  Created by Nandi Wong on 22/9/2024.
//

import Foundation
import Cocoa

typealias CallbackFuncType = @convention(c) (CGSEventType, UnsafeMutableRawPointer?, UInt32, UnsafeMutableRawPointer?) -> ()



class SpaceManager: ObservableObject {
    let connection: CGSConnectionID
    
    init() {
        connection = CGSDefaultConnectionForThread()
    }
    func startMonitoring() {
        let wrappedCallback: CallbackFuncType = workspaceNotificationCallback
        // Register for workspace notifications (e.g., space changes)
        CGSRegisterNotifyProc(wrappedCallback, kCGSWorkspaceDidChange, nil)
        
        let spaces = getAllSpaces()
        spaces?.forEach { spaceID in
            print("Space ID: \(spaceID)")
        }
        
        
    }
    
    func changeSpace(spaceID: Int) -> Void {
        var displayIDs = [CGDirectDisplayID](repeating: 0, count: 10) // Initial capacity

        var displayCount: CGDisplayCount = 0
        // Passing the pointer of array and fill it up with the displayIDs
        CGSGetOnlineDisplayList(10, &displayIDs, &displayCount)
        
        // DEBUG
        print("display : \(displayIDs)")
        print("displayCount : \(displayCount)")
        
        // Fetech all spaces
        let unmanagedDisplaySpaces = CGSCopyManagedDisplaySpaces(CGSMainConnectionID());
        
        // Full part here.
        // It returns an unmanaged (raw pointers) of an CFArray of an untyped Dictionary
        let displaySpaces = unmanagedDisplaySpaces?.takeRetainedValue() as? [[String: Any]]
        print("info: \(displaySpaces)")
        if displaySpaces?.count ?? 0 > 0 {
            let space = displaySpaces?[2]
            let displayRef:CFString = space?["Display Identifier"] as! CFString
            print("changing \(displayRef)")
            
            // not sure why it accepts the display identifier but not the displayID, but it will panic with BAD ACCESS if passing the displayID
            // so guessing the string display identifier is the thing we needed
            CGSManagedDisplaySetCurrentSpace(CGSMainConnectionID(),displayRef, spaceID)
            
            // try using the ShowSpaces, but didn't help :(
            let spaces = [spaceID].map { NSNumber(value: $0) } as NSArray
            CGSShowSpaces(CGSMainConnectionID(), spaces)
            
            // somehow it works. when you call the next time the current screen returned is changed
            // however the UI is not changed. and it becomes kind of weird as the application on the space stays, but somehow "stick" onto the screen?
            // some other references stating we might need to tweak using the windows SPI
            // e.g. https://github.com/fjolnir/xnomad/blob/0efd72439f183289da713b80266a5f974149b789/WindowManager.tq#L74
            // TODO: after setting currnet maybe we should need to do something
            
            
        }
        
    }
        
    func stopMonitoring() {
        // Implement cleanup logic if needed
        print("Stopped monitoring space changes.")
    }
    
    // Retrieve all spaces
    func getAllSpaces() -> [CGSSpaceID]?{
        guard let spaces = CGSCopySpaces(CGSMainConnectionID(), kCGSAllSpacesMask) else {
            return nil
        }
        
        // not entirely sure if we should retain the values here.
        return spaces.takeRetainedValue() as? [CGSSpaceID]
    }
    

}


// Define the callback function to receive space change events
func workspaceNotificationCallback(type: CGSEventType, data: UnsafeMutableRawPointer?, dataLength: UInt32, userData: UnsafeMutableRawPointer?) {
    print("Space change detected!")
    
    // You can use CGSGetActiveSpace to get the current space ID
    let currentSpaceID = CGSGetActiveSpace(0)
    print("Current space ID: \(currentSpaceID)")
}
