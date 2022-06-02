//
//  AppCoordinator.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/17.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
        self.rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    override func start() {
        showCollection()
    }
    
    private func showCollection() {
        defer { setRoot(viewController: rootViewController) }
        
        let nftCollectionCoordinator = NFTCollectionCoordinator(navigationController: rootViewController)
        start(coordinator: nftCollectionCoordinator)
    }
    
    private func setRoot(viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
