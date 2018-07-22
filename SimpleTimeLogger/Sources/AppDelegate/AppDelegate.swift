//
//  AppDelegate.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let realm = try? Realm() else { return true }
        let viewController = TimeRegistrationListViewController(viewModel:
                                TimeRegListViewModelImplementation(reader:
                                    RealmStorageService(realm: realm)))
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
