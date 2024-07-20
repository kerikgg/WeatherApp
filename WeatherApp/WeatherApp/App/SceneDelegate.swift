//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by kerik on 16.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController = WeatherViewController(viewModel: WeatherViewModel())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

