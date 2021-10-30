//
//  SceneDelegate.swift
//  ProgrammerCalc
//
//  Created by Ivan Ghiba on 12.04.2020.
//  Copyright © 2020 ighiba. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // List of known shortcut actions
    enum ActionType: String {
        case copyInput = "ru.ighiba.ProgrammerCalc.copyInput"
        case copyOutput = "ru.ighiba.ProgrammerCalc.copyOutput"
    }
    
    static let favoriteIdentifierInfoKey = "FavoriteIdentifier"
    
    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        /** Process the quick action if the user selected one to launch the app.
            Grab a reference to the shortcutItem to use in the scene.
        */
        if let shortcutItem = connectionOptions.shortcutItem {
            // Save it off for later when we become active.
            savedShortCutItem = shortcutItem
        }
        
        // Using scene without storyboard
        // Main is PCalcViewController
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        // Set root vc
        let rootVC = PCalcViewController()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        // Splash screen (for smoother transition from launch screen)
        let splashScreen = UIView(frame: UIScreen.main.bounds)
        splashScreen.backgroundColor = .black
        rootVC.view.addSubview(splashScreen)
        // animate transition
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveLinear, animations: {
            splashScreen.alpha = 0
        }, completion: { _ in
            splashScreen.removeFromSuperview()
        })
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        // rewrite shortcut
        savedShortCutItem = shortcutItem
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if savedShortCutItem != nil {
            handleShortCutItem(shortcutItem: savedShortCutItem)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {

        var inputResult: String = ""
        var outputResult: String = ""
        
        var inputSystem: String = ""
        var outputSystem: String = ""
        
        // Saving data from PCalcViewController
        if let vc = window?.rootViewController as? PCalcViewController {
            // Save
            vc.saveCalcState()
            // Get data for shortcuts
            let calcStateStorage = CalcStateStorage()
            let data = calcStateStorage.safeGetData()
            inputResult = data.mainLabelState
            outputResult = data.converterLabelState
            
            inputSystem = vc.calculator.systemMain?.rawValue ?? ""
            outputSystem = vc.calculator.systemConverter?.rawValue ?? ""
        }
        
        // Transform each favorite contact into a UIApplicationShortcutItem.
        let application = UIApplication.shared
        
        let icon = UIApplicationShortcutIcon(systemImageName: "doc.on.doc")
        let shortcutItems = [ UIApplicationShortcutItem(type: "ru.ighiba.ProgrammerCalc.copyInput",
                                                        localizedTitle: NSLocalizedString("Copy last input", comment: "") + " (\(inputSystem))",
                                                        localizedSubtitle: inputResult,
                                                        icon: icon,
                                                        userInfo: nil),
                              UIApplicationShortcutItem(type: "ru.ighiba.ProgrammerCalc.copyOutput",
                                                        localizedTitle: NSLocalizedString("Copy last output", comment: "") + " (\(outputSystem))",
                                                        localizedSubtitle: outputResult,
                                                        icon: icon,
                                                        userInfo: nil)]
        
        application.shortcutItems = shortcutItems
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - Application Shortcut Support
    
    func copyInputFor(shortcutItem: UIApplicationShortcutItem) {
        // Pasteboard
        let board = UIPasteboard.general
        
        switch ActionType(rawValue: shortcutItem.type) {
        case .copyInput:
            // Copy input
            let board = UIPasteboard.general
            // change clipboard with new value from subtitle and delete all spaces in string
            board.string = shortcutItem.localizedSubtitle?.removeAllSpaces()
        case .copyOutput:
            // Copy output
            board.string = shortcutItem.localizedSubtitle?.removeAllSpaces()
        default:
            // do nothing
            break
        }
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) {
        copyInputFor(shortcutItem: shortcutItem)
    }

}
