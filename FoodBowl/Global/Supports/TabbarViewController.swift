//
//  TabbarViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

final class TabbarViewController: UITabBarController {
    private let mainViewController = UINavigationController(rootViewController: MainViewController())
    private let mapViewController = UINavigationController(rootViewController: MapViewController())
    private let searchViewController = UINavigationController(rootViewController: SearchViewController())
    private let profileViewController = UINavigationController(rootViewController: ProfileViewController(isOwn: true))

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController.tabBarItem.image = ImageLiteral.btnMain
        mainViewController.tabBarItem.title = "메인"

        mapViewController.tabBarItem.image = ImageLiteral.btnMap
        mapViewController.tabBarItem.title = "지도"

        searchViewController.tabBarItem.image = ImageLiteral.btnSearch
        searchViewController.tabBarItem.title = "검색"

        profileViewController.tabBarItem.image = ImageLiteral.btnProfile
        profileViewController.tabBarItem.title = "프로필"

        tabBar.tintColor = .mainPink
        tabBar.backgroundColor = .mainBackground
        setViewControllers([
            mainViewController,
            mapViewController,
            searchViewController,
            profileViewController
        ], animated: true)

        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = .init()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .mainBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
