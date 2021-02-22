//
//  AppDelegate.swift
//  BancaPushNotification
//
//  Created by Shanmugasundharam on 17/02/2021.
//

import UIKit
import UserNotifications

enum Identifiers {
  static let viewAction = "HOMEVIEW"
  static let newsCategory = "NEWS_CATEGORY"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let notificationOption = launchOptions?[.remoteNotification]
        if
          let notification = notificationOption as? [String: AnyObject],
          let aps = notification["aps"] as? [String: AnyObject] {
          //NewsItem.makeNewsItem(aps)
          (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
        
        // push notification
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        return true
    }

    func registerForPushNotifications(){
     
        UNUserNotificationCenter.current()
          .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            let viewAction = UNNotificationAction(
              identifier: Identifiers.viewAction,
              title: "View",
              options: [.foreground])
            let newsCategory = UNNotificationCategory(
              identifier: Identifiers.newsCategory,
              actions: [viewAction],
              intentIdentifiers: [],
              options: []
            )
            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
            self?.getNotificationSettings()
          }
    }
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
  }

// MARK : extinson UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    // These delegate methods MUST live in App Delegate and nowhere else!

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String : AnyObject] {
    
        }
        //completionHandler()
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String : AnyObject] {
            

            if !userInfo.isEmpty {
                let view = ViewController()
                window?.rootViewController?
                         .present(view, animated: true, completion: nil)
            }
        }
        completionHandler()
    }
}
