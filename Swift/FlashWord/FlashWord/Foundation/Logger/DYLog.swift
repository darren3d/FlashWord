//
//  DYLog.swift
//  FlashWord
//
//  Created by darrenyao on 16/6/10.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let DYLog: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.defaultInstance()
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose: .lightGrey,
        .Debug: .darkGrey,
        .Info: .darkGreen,
        .Warning: .orange,
        .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    
    // Set via Build Settings, under Other Swift Flags
    #if DEBUG
        log.removeLogDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier)
        log.addLogDestination(XCGNSLogDestination(owner: log, identifier: XCGLogger.Constants.nslogDestinationIdentifier))
        log.logAppDetails()
    #else
        let logPath: NSURL = appDelegate.cacheDirectory.URLByAppendingPathComponent("XCGLogger_Log.txt")
        log.setup(.Warning, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
    #endif
    return log
}()