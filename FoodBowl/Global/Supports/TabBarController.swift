//
//  TabBarController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

final class TabBarController: UITabBarController {
    private let mapViewController = UINavigationController(rootViewController: MapViewController())
    private let feedViewController = UINavigationController(rootViewController: FeedViewController())
    private let bookmarkViewController = UINavigationController(rootViewController: BookmarkViewController())
    private let settingViewController = UINavigationController(rootViewController: SettingViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewController.tabBarItem.image = ImageLiteral.btnMap.resize(to: CGSize(width: 20, height: 20))
            .withRenderingMode(.alwaysTemplate)
        mapViewController.tabBarItem.title = "지도"

        feedViewController.tabBarItem.image = ImageLiteral.btnFeed.resize(to: CGSize(width: 20, height: 20))
            .withRenderingMode(.alwaysTemplate)
        feedViewController.tabBarItem.title = "발자취"

        bookmarkViewController.tabBarItem.image = ImageLiteral.btnBookmark.resize(to: CGSize(width: 20, height: 20))
            .withRenderingMode(.alwaysTemplate)
        bookmarkViewController.tabBarItem.title = "북마크"

        settingViewController.tabBarItem.image = ImageLiteral.btnSetting.resize(to: CGSize(width: 20, height: 20))
            .withRenderingMode(.alwaysTemplate)
        settingViewController.tabBarItem.title = "설정"

        tabBar.tintColor = .mainColor
        tabBar.backgroundColor = .mainBackground
        setViewControllers([
            mapViewController,
            feedViewController,
            bookmarkViewController,
            settingViewController
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
