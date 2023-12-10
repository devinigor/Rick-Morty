//
//  SceneDelegate.swift
//  rick and morty
//
//  Created by Игорь Девин on 10.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let viewController = LaunchScreenViewController()
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.windowScene = windowScene
    }
}

