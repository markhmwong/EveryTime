//
//  LocalNotificationsHandler.swift
//  EveryTime
//
//  Created by Mark Wong on 17/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
import UserNotifications
import UIKit

enum NotificationDictionaryKeys: String {
    case Title = "title"
    case Body = "body"
}

class LocalNotificationsService: NSObject {
    private var content: UNMutableNotificationContent?
    private var identifier: String? // Domain name style - RecipeName.StepName.Priority
    private var trigger: UNTimeIntervalNotificationTrigger?
    private let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound]
    
    class var shared: LocalNotificationsService {
        struct Static {
            static let instance: LocalNotificationsService = LocalNotificationsService()
        }
        return Static.instance
    }
    
    func notificationCenterInstance() -> UNUserNotificationCenter {
        return notificationCenter
    }

    func requestAuth() {
        notificationCenterInstance().requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Local Notifications are off")
            }
        }
    }
    
    func addRecipeWideNotification(identifier: String = "", notificationContent: [String: String]? = nil, timeRemaining: Double) {
        requestAuth()
        organiseNotification(timeRemaining, notificationContent!)
        addToNotificationCenter(identifier)
    }
    
    //Must call prepareNotification first or content and trigger will be empty
    func addToNotificationCenter(_ id: String) {
        guard let c = content, let t = trigger else {
            print("please call preparenotification first")
            return
        }
        let request = UNNotificationRequest(identifier: id,
                                            content: c, trigger: t)
        notificationCenterInstance().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("something went wrong \(error.localizedDescription)")
            }
        })
    }

    private func organiseNotification(_ timeRemaining: Double, _ notificationContent: [String: String]) {
        content = nil
        trigger = nil

        content = prepareContent(title: notificationContent[NotificationDictionaryKeys.Title.rawValue]!)
        trigger = prepareTimeInterval(fireIn: timeRemaining)
    }
    
    private func prepareTimeInterval(fireIn: Double) -> UNTimeIntervalNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireIn,
                                                        repeats: false)
        return trigger
    }
    
    private func prepareContent(title: String = "Recipe - Unknown") -> UNMutableNotificationContent? {
        let c = UNMutableNotificationContent()
        c.title = "Complete"
        c.body = "The recipe \(title) is done!"
        c.sound = UNNotificationSound.default
        return c
    }
    
    func locationNotificationIdentifierFor(recipe: RecipeEntity) -> String {
        guard let name = recipe.recipeName, let createdDate = recipe.createdDate else { return "name or date incorrect" }
        return "\(name).\(createdDate)"
    }
}
