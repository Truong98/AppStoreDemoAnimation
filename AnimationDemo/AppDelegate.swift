//
//  AppDelegate.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 4/5/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabbarVC = UITabBarController()
        
        let vc1 = HomeViewController()
        vc1.title = "Show Tabbar"
        vc1.isTabbarHiddenWhenDismissingDestVC = false
        let nVC1 = UINavigationController(rootViewController: vc1)
        nVC1.tabBarItem = UITabBarItem(title: "Show Tabbar", image: UIImage(named: "icn_tab_contact_normal")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "icn_tab_contact_selected")?.withRenderingMode(.alwaysOriginal))
        
        let vc2 = HomeViewController()
        vc2.title = "Show Tabbar"
        vc2.isTabbarHiddenWhenDismissingDestVC = true
        let nVC2 = UINavigationController(rootViewController: vc2)
        nVC2.tabBarItem = UITabBarItem(title: "Hide Tabbar", image: UIImage(named: "icn_tab_more_normal")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "icn_tab_more_selected")?.withRenderingMode(.alwaysOriginal))
        
        tabbarVC.viewControllers = [nVC1, nVC2]
        
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

