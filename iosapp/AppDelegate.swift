//
//  AppDelegate.swift
//  iosapp
//
//  Created by alexander on 29.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance

        let app = UITabBarAppearance()
        app.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = app
        return true

    }
}
