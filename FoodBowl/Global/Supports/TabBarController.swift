//
//  TabBarController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

final class TabBarController: UITabBarController {
    private let vc1 = UINavigationController(rootViewController: FriendViewController())
    private let vc2 = UINavigationController(rootViewController: FriendViewController())
    private let vc3 = UINavigationController(rootViewController: FriendViewController())
    private let vc4 = UINavigationController(rootViewController: ProfileViewController(isOwn: true))

    override func viewDidLoad() {
        super.viewDidLoad()

        vc1.tabBarItem.image = ImageLiteral.friends
            .resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        vc1.tabBarItem.title = "친구들"

        vc2.tabBarItem.image = ImageLiteral.bookmark
            .resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        vc2.tabBarItem.title = "북마크"

        vc3.tabBarItem.image = ImageLiteral.univ
            .resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        vc3.tabBarItem.title = "대학가"

        vc4.tabBarItem.image = ImageLiteral.profile
            .resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        vc4.tabBarItem.title = "프로필"

        tabBar.tintColor = .mainPink
        tabBar.backgroundColor = .mainBackground
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)

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
