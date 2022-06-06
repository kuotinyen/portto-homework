//
//  NFTAPIWorker.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/18.
//

import Foundation
import Alamofire

class NFTAPIWorker {
    func fetchNFTItems(offset: Int) async -> [NFTAsset]? {
        do {
            let parameters: Parameters = [
                "format": "json",
                "owner": Const.Owner,
                "offset": "\(offset)",
                "limit": Const.Limit
            ]
            let urlString = "https://api.opensea.io//api/v1/assets"
            return try await AF.request(urlString,parameters: parameters, headers: Const.Headers)
                .serializingDecodable(NFTAssetListResponse.self)
                .value.assets
        } catch {
            print("#### \(#function) failed, error: \(error)")
            return nil
        }
    }
}

// MARK: - Const

private extension NFTAPIWorker {
    enum Const {
        static let Limit = 20
        static let Owner = "0x19818f44faf5a217f619aff0fd487cb2a55cca65"
        static let Headers: HTTPHeaders = [
            "X-API-KEY": "5b294e9193d240e39eefc5e6e551ce83",
        ]
        
        static let JsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
    }
}

// MARK: - Response Objects

struct NFTAsset: Decodable {
    var imageUrl: URL? // For update image url since the image url is empty now
    let name: String?
    let collectionName: String?
    let description: String?
    let permalink: URL?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl, name, description, permalink
        case collection
    }
    
    enum CollectionKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: CodingKeys.self)
        let collectionContainer = try outerContainer.nestedContainer(keyedBy: CodingKeys.self,
                                                                     forKey: .collection)
        self.imageUrl = try? outerContainer.decode(URL.self, forKey: .imageUrl)
        self.name = try? outerContainer.decode(String.self, forKey: .name)
        self.collectionName = try? collectionContainer.decode(String.self, forKey: .name)
        self.description = try? outerContainer.decode(String.self, forKey: .description)
        self.permalink = try? outerContainer.decode(URL.self, forKey: .permalink)
    }
}

struct NFTAssetListResponse: Decodable {
    let assets: [NFTAsset]
}
