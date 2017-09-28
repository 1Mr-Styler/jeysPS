//
//  Notifix.swift
//  JPS
//
//  Created by Jerry U. on 9/18/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class Notifix: NSObject {

    func showNotification(title: String) -> Void {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = "The body of this Swift notification"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasActionButton = true
        notification.actionButtonTitle = "Leave me alone"
        notification.responsePlaceholder = "Placeholder"
        notification.hasReplyButton = true
        
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func GMAgent(_ activity: String, ga: String) -> Void {
        let notification = NSUserNotification()
        notification.title = "Are you still \(activity)?"
        notification.subtitle = ga
        notification.informativeText = "Ignore this message to switch current activity to \(activity)"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        notification.hasReplyButton = true
        notification.responsePlaceholder = "Reply No to prevent activity-switching"
        
        
        NSUserNotificationCenter.default.deliver(notification)
    }
}
