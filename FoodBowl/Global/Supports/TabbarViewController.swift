//
//  TabbarViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

final class TabbarViewController: UITabBarController {
    private let mainViewController = UINavigationController(rootViewController: MainViewController())
    private let searchViewController = UINavigationController(rootViewController: SearchViewController())
    private let messageViewController = UINavigationController(rootViewController: MessageViewController())
    private let profileViewController = UINavigationController(rootViewController: ProfileViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController.tabBarItem.image = ImageLiteral.btnMain
        mainViewController.tabBarItem.title = "메인"

        searchViewController.tabBarItem.image = ImageLiteral.btnSearch
        searchViewController.tabBarItem.title = "검색"

        messageViewController.tabBarItem.image = ImageLiteral.btnMessage
        messageViewController.tabBarItem.title = "메세지"

        profileViewController.tabBarItem.image = ImageLiteral.btnProfile
        profileViewController.tabBarItem.title = "프로필"

        tabBar.tintColor = .mainPink
        tabBar.backgroundColor = .white
        setViewControllers([
            mainViewController,
            searchViewController,
            messageViewController,
            profileViewController
        ], animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}