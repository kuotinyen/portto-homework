//
//  NFTDetailViewController.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/20.
//

import UIKit
import SafariServices

class NFTDetailViewController: UIViewController {
    typealias Section = NFTDetailSection
    typealias Item = NFTDetailItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Coordinator = NFTDetailCoordinator
    
    weak var coordinator: Coordinator?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var nft: NFTAsset? { coordinator?.nft }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = nft?.collectionName
        setupCollectionView()
        setupDataSource()
        populate(with: nft)
    }
    
    @objc func tapPermalink() {
        coordinator?.navigateToSafariPage()
    }
}

// MARK: - Private helpers

extension NFTDetailViewController {
    
    // MARK: Data
    
    private func populate(with nft: NFTAsset?) {
        guard let nft = nft else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        if let imageUrl = nft.imageUrl {
            snapshot.appendItems([Item.init(itemType: .image(imageUrl))], toSection: .image)
        }
        
        if let name = nft.name {
            snapshot.appendItems([Item.init(itemType: .text(name))], toSection: .name)
        }
        
        if let description = nft.description {
            snapshot.appendItems([Item.init(itemType: .text(description))], toSection: .description)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupDataSource() {
        let imageCellRegistration = UICollectionView.CellRegistration<NFTDetailImageCell, NFTDetailItem> { (cell, indexPath, item) in
            guard case let .image(imageUrl) = item.itemType else { return }
            cell.populate(with: imageUrl)
        }
        
        let textCellRegistration = UICollectionView.CellRegistration<NFTDetailTextCell, NFTDetailItem> { (cell, indexPath, item) in
            guard case let .text(text) = item.itemType else { return }
            cell.populate(with: text)
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch Section(rawValue: indexPath.section) {
            case .image:
                let cell = collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: item)
                cell.didUpdateImageHeight = { [weak self] in
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                }
                return cell
            case .name, .description:
                return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: item)
            case .none:
                return nil
            }
        }
    }
    
    // MARK: Views
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
        
        let permalinkButton = UIButton()
        permalinkButton.backgroundColor = .systemBlue
        permalinkButton.setTitle("Link", for: .normal)
        permalinkButton.addTarget(self, action: #selector(tapPermalink), for: .touchUpInside)
        view.addSubview(permalinkButton)
        permalinkButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
        }
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            let estimatedHeight: CGFloat = sectionType == .image ? 252 : 44
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedHeight))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
