//
//  TabBarController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

final class TabBarController: UITabBarController {
    private let vc1 = UINavigationController(rootViewController: FriendViewController())
    private let vc2 = UINavigationController(rootViewController: FindViewController())
    private let vc3 = UINavigationController(rootViewController: UnivViewController())
    private let vc4 = UINavigationController(rootViewController: ProfileViewController(isOwn: true))

    override func viewDidLoad() {
        super.viewDidLoad()

        vc1.tabBarItem.image = ImageLiteral.friends
            .resize(to: CGSize(width: 20, height: 20))
        vc1.tabBarItem.title = "친구들"

        vc2.tabBarItem.image = ImageLiteral.search
            .resize(to: CGSize(width: 20, height: 20))
        vc2.tabBarItem.title = "찾기"

        vc3.tabBarItem.image = ImageLiteral.univ
            .resize(to: CGSize(width: 20, height: 20))
        vc3.tabBarItem.title = "대학가"

        vc4.tabBarItem.image = ImageLiteral.profile
            .resize(to: CGSize(width: 20, height: 20))
        vc4.tabBarItem.title = "프로필"

        tabBar.tintColor = .mainPink
        tabBar.backgroundColor = .mainBackground
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)

        let tabBarAppearance: UITabBarAppearance = .init()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .mainBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
