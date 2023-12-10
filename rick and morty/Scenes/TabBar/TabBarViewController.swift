//
//  TabBarViewController.swift
//  rick and morty
//
//  Created by Игорь Девин on 29.11.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = EpisodesViewController()
        let episodesNavigationController = UINavigationController(rootViewController: firstViewController)
        firstViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "HomeOff"), selectedImage: UIImage(named: "HomeOn"))

        let secondViewController = FavouritesViewControllers()
        let favouritesNavigationController = UINavigationController(rootViewController: secondViewController)
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "FavoriteOff"), selectedImage: UIImage(named: "FavoriteOn"))

        viewControllers = [episodesNavigationController, favouritesNavigationController]
    }
}

