//
//  NFTCollectionViewController.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/17.
//

import UIKit
import SnapKit
import Combine

class NFTCollectionViewController: UIViewController {
    typealias Section = NFTCollectionSection
    typealias Item = NFTCollectionItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Coordinator = NFTCollectionCoordinator
    typealias ViewModel = NFTCollectionViewModel
    
    weak var coordinator: Coordinator?
    
    #warning("TODO: Test every viewState with loadingView, emptyView")
    private var collectionView: UICollectionView!
    private var loadingView = IndicatorView()
    private let infiniteScrollingIndicatorView = IndicatorView()
    
    #warning("TODO: Dummy Empty view")
    private var emptyView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .red
        return backgroundView
    }()
    
    private var dataSource: DataSource!
    private let viewModel = ViewModel()
    private var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDataSource()
        setupViewModel()
        viewModel.fetchData()
    }
}

// MARK: - Delegate

extension NFTCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath), let nft = item.nft else { return }
        coordinator?.navigateToDetailPage(nft: nft)
    }
}

// MARK: - Private helpers

extension NFTCollectionViewController {
    
    // MARK: Models
    
    private func setupViewModel() {
        viewModel.$viewState.sink { [weak self] viewState in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch viewState {
                case .initialize:
                    break
                case .loading:
                    self.loadingView.isHidden = false
                    self.collectionView.isHidden = true
                    self.emptyView.isHidden = true
                case .upToDate(let isFirstTime, let hasMoreContent):
                    self.loadingView.isHidden = true
                    self.collectionView.isHidden = false
                    self.emptyView.isHidden = true
                    if isFirstTime && hasMoreContent {
                        self.addInfiniteScrollIndicator()
                    }
                    
                    self.collectionView.showInfiniteScrolling = hasMoreContent
                    self.stopInfiniteScrollAnimating()
                case .loadingMore:
                    self.loadingView.isHidden = true
                    self.collectionView.isHidden = false
                    self.emptyView.isHidden = true
                case .error:
                    self.loadingView.isHidden = true
                    self.collectionView.isHidden = true
                    self.emptyView.isHidden = false
                    self.stopInfiniteScrollAnimating()
                }
            }
        }.store(in: &bag)
        
        viewModel.$items.sink { [weak self] items in
            DispatchQueue.main.async {
                self?.populate(items: items)
            }
        }.store(in: &bag)
    }
    
    private func addInfiniteScrollIndicator() {
        collectionView.adkAddInfiniteScrolling(withHandle: infiniteScrollingIndicatorView) { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        
        infiniteScrollingIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(collectionView)
            make.leading.bottom.equalToSuperview()
        }
    }
    
    private func stopInfiniteScrollAnimating() {
        guard let infiniteScrollingContentView = self.collectionView.infiniteScrollingContentView else { return }
        infiniteScrollingContentView.stopAnimating()
    }
    
    private func populate(items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<NFTCollectionCell, Item> { (cell, indexPath, item) in
            cell.populate(with: item)
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    // MARK: Views
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "NFT Assets"
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingView.isHidden = true
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
        emptyView.isHidden = true
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
