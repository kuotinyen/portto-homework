//
//  NFTCollectionViewModel.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/31.
//

import Foundation
import Combine

enum ViewState {
    case initialize
    case loading
    case upToDate(isFirstTime: Bool, hasMoreContent: Bool)
    case loadingMore
    case error
}

class NFTCollectionViewModel {
    @Published var items: [NFTCollectionItem] = []
    @Published var viewState: ViewState = .initialize
    
    #warning("Debug config")
    private var usingLocalJsonFile = true
    
    private var itemOffset: Int = 0
    private var isFirstTime: Bool = true
    private let apiWorker = NFTAPIWorker()
    
    func fetchData() {
        #warning("FIXME: Remove config and logic when API image url work.")
        guard !usingLocalJsonFile else {
            items = mockNFTAssets.compactMap { NFTCollectionItem(nft: $0) }
            viewState = .upToDate(isFirstTime: true, hasMoreContent: true)
            return
        }
        
        if isFirstTime {
            viewState = .loading
            Task {
                guard let assets = await apiWorker.fetchNFTItems(offset: itemOffset) else {
                    viewState = .error
                    return
                }

                items = assets.compactMap { NFTCollectionItem(nft: $0) }
                viewState = .upToDate(isFirstTime: true, hasMoreContent: !assets.isEmpty)
                itemOffset += 20
                isFirstTime = false
            }
        } else {
            viewState = .loadingMore
            Task {
                guard let assets = await apiWorker.fetchNFTItems(offset: itemOffset) else {
                    viewState = .upToDate(isFirstTime: false, hasMoreContent: false)
                    return
                }
                
                items = items + assets.compactMap { NFTCollectionItem(nft: $0) }
                viewState = .upToDate(isFirstTime: false, hasMoreContent: !assets.isEmpty)
                itemOffset += 20
            }
        }
    }
}
