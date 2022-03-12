//
//  AppDelegate.swift
//  VideoPlayerUI
//
//  Created by Aaron Lee on 2022/03/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow()
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()

    return true
  }
}
