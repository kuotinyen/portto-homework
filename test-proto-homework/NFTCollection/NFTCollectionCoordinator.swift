//
//  NFTCollectionCoordinator.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/17.
//

import UIKit

class NFTCollectionCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private var nftCollectionViewController: NFTCollectionViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let nftCollectionViewController = NFTCollectionViewController()
        nftCollectionViewController.coordinator = self
        navigationController.pushViewController(nftCollectionViewController, animated: true)
    }
    
    func navigateToDetailPage(nft: NFTAsset) {
        let detailCoordinator = NFTDetailCoordinator(navigationController: navigationController)
        detailCoordinator.nft = nft
        start(coordinator: detailCoordinator)
    }
}
