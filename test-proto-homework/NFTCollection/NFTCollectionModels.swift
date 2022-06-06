//
//  NFTCollectionModels.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/20.
//

import Foundation

enum NFTCollectionSection: Int, Hashable {
    case main
}

class NFTCollectionItem {
    let nft: NFTAsset?
    init(nft: NFTAsset?) {
        self.nft = nft
    }
}

extension NFTCollectionItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(nft?.collectionName)
        hasher.combine(nft?.name)
        hasher.combine(nft?.imageUrl)
    }

    static func == (lhs: NFTCollectionItem, rhs: NFTCollectionItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
