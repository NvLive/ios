//
//  AppDelegate.swift
//  NLive
//
//  Created by EVGENY ANTROPOV on 12/08/2017.
//  Copyright © 2017 Eugene Antropov. All rights reserved.
//

import UIKit
import ReSwift
import StatusBarNotificationCenter
import AudioToolbox
import AVFoundation

#if DEBUG
let App_Debug:Bool = true
#else
let App_Debug:Bool = true
#endif

// Initializing ReSwift
let store = Store<AppState>(
    reducer: appReducer,
    state: AppState()
)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var router: AppRouter?
    var reachabilityService: ReachabilityService?
    var task = UIBackgroundTaskInvalid
    
    // Overriding system fonts
    override init() {
        super.init()
//        UIFont.overrideInitialize()
    }
}

extension AppDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Starting a router
        router = AppRouter()
        store.dispatch(RouterAction.loadDefaultSequence)
        
        // Starting Reachability Service
        // for network availability monitoring
        reachabilityService = ReachabilityService(withBaseWindow: window!)        
        configureStyle()
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        task = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate {
    
    internal func setRootViewController(_ rootViewController:UIViewController, animated:Bool) {
        if let window = self.window {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
}

extension AppDelegate {
    
    fileprivate func configureStyle() {
        
        UINavigationBar.appearance().tintColor = Color.Navigation.tinted.tint
//        UINavigationBar.appearance().backgroundColor = Color.Navigation.tinted.background

//        UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: Color.Navigation.tinted.background), for: .default)
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navbar_bg")!.resizableImage(withCapInsets: UIEdgeInsets(top: 180-44/2, left: 240-375/2, bottom: 0, right: 0)), for: .default)
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navbar_bg")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)

        UINavigationBar.appearance().contentMode = .center
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false

        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: Font.Color.opposite,
            NSFontAttributeName: Font.largeMedium
        ]

//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "navbar_back")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "navbar_back")
//        
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back-button-opposite")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back-button-opposite")
    }
}

