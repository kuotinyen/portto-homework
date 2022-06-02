//
//  NFTDetailCoordinator.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/6/2.
//

import UIKit
import SafariServices

class NFTDetailCoordinator: BaseCoordinator {
    var nft: NFTAsset?
    
    private let navigationController: UINavigationController
    private var nftDetailViewController: NFTDetailViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let nftDetailViewController = NFTDetailViewController()
        nftDetailViewController.coordinator = self
        self.nftDetailViewController = nftDetailViewController
        navigationController.pushViewController(nftDetailViewController, animated: true)
    }
    
    func navigateToSafariPage() {
        guard let permalink = nft?.permalink else { return }
        let safariViewController = SFSafariViewController(url: permalink)
        nftDetailViewController?.present(safariViewController, animated: true)
    }
}
