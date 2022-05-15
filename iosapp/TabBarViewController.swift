//
//  TabBarViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 25.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = Color.tabBarBarTintColor.color
        tabBar.tintColor = Color.tabBarTintColor.color
        tabBar.layer.cornerRadius = 10
        tabBar.backgroundColor = .white

        let mainVC =  FirstNestingLevelViewController()
        let favoriteVC = FavoriteViewController()
        let addVC = AdsViewController()
        let chatVC = ChatViewController()
        let profileVC = ControllerFactory.get(ProfileViewController.self)
        viewControllers = [
            createTabBarItem(tabBarTitle: "Главная", tabBarImage: #imageLiteral(resourceName: "home_icon"), viewController: mainVC),
            createTabBarItem(tabBarTitle: "Избранное", tabBarImage: #imageLiteral(resourceName: "favorite_icon"), viewController: favoriteVC),
            createTabBarItem(tabBarTitle: "Объявления", tabBarImage: #imageLiteral(resourceName: "plusGradient"), viewController: addVC),
            createTabBarItem(tabBarTitle: "Сообщения", tabBarImage: #imageLiteral(resourceName: "chat_icon"), viewController: chatVC),
            createTabBarItem(tabBarTitle: "Профиль", tabBarImage: #imageLiteral(resourceName: "home_icon"), viewController: profileVC)
        ]
    }

    func createTabBarItem(
        tabBarTitle: String,
        tabBarImage: UIImage,
        viewController: UIViewController
    ) -> UINavigationController {
            let navCont = UINavigationController(rootViewController: viewController)
            navCont.tabBarItem.title = tabBarTitle
            navCont.tabBarItem.image = tabBarImage
        return navCont
    }
}
