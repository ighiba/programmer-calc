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
    
    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem!
    
    private let storage = PCalcStorage()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        storage.loadAll()

        if let shortcutItem = connectionOptions.shortcutItem {
            savedShortCutItem = shortcutItem
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let rootVC = CalculatorModuleAssembly.configureModule()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        let splashScreen = UIView(frame: UIScreen.main.bounds)
        splashScreen.backgroundColor = .black
        rootVC.view.addSubview(splashScreen)

        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveLinear, animations: {
            splashScreen.alpha = 0
        }, completion: { _ in
            splashScreen.removeFromSuperview()
        })
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        savedShortCutItem = shortcutItem
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if savedShortCutItem != nil {
            handleShortCutItem(shortcutItem: savedShortCutItem)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        storage.saveAll()

        let calculatorState = CalculatorState.shared
        let conversionSettings = ConversionSettings.shared
        
        let inputResult = calculatorState.lastLabelValues.input
        let outputResult = calculatorState.lastLabelValues.output
        
        let inputSystem = conversionSettings.systemMain.title
        let outputSystem = conversionSettings.systemConverter.title
        
        let application = UIApplication.shared
        
        let icon = UIApplicationShortcutIcon(systemImageName: "doc.on.doc")
        
        application.shortcutItems = [
            UIApplicationShortcutItem(
                type: ActionType.copyInput.rawValue,
                localizedTitle: NSLocalizedString("Copy last input", comment: "") + " (\(inputSystem))",
                localizedSubtitle: inputResult,
                icon: icon,
                userInfo: nil
            ),
            UIApplicationShortcutItem(
                type: ActionType.copyOutput.rawValue,
                localizedTitle: NSLocalizedString("Copy last output", comment: "") + " (\(outputSystem))",
                localizedSubtitle: outputResult,
                icon: icon,
                userInfo: nil
            )
        ]
    }
    
    // MARK: - Application Shortcut Support
    
    func copyInputFor(shortcutItem: UIApplicationShortcutItem) {
        let pasteboard = UIPasteboard.general
        
        switch ActionType(rawValue: shortcutItem.type) {
        case .copyInput:
            pasteboard.string = shortcutItem.localizedSubtitle?.removedAllSpaces()
        case .copyOutput:
            pasteboard.string = shortcutItem.localizedSubtitle?.removedAllSpaces()
        default:
            break
        }
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) {
        copyInputFor(shortcutItem: shortcutItem)
    }
}
