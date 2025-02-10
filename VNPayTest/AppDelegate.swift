//
//  AppDelegate.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Repo
        AppLocator.shared.register(PicsumRepository() as PicsumRepositoryType)
        //UseCase
        AppLocator.shared.register(PicsumUseCase() as PicsumUseCaseType)
       
        setupRootController(PicsumHomeViewController())
       
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupRootController(_ controller: BaseViewController, _ isHiddenNavigationBar: Bool = false) {
        let navController = UINavigationController(rootViewController: controller)
        navController.setNavigationBarHidden(isHiddenNavigationBar, animated: false)
        if self.window == nil { self.window = UIWindow(frame: UIScreen.main.bounds) }
        self.window?.backgroundColor = .white
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }


}

