//
//  MockData.swift
//  test-proto-homework
//
//  Created by Ting Yen Kuo on 2022/5/20.
//

import Foundation

let mockNFTAssetResponse: NFTAssetListResponse = decodable(filename: "nftassets.json")
let mockNFTAssets: [NFTAsset] = mockNFTAssetResponse.assets

func decodable<T: Decodable>(filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        return try Constant.JSONDecoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func data(filename: String) -> Data {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError(String(format: Constant.FatalMessageFormat.FileCanNotLoad,
                          filename))
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError(String(format: Constant.FatalMessageFormat.FileCanNotLoad,
                          filename, error.localizedDescription))
    }
    return data
}

// MARK: - Constant

private enum Constant {
    enum FatalMessageFormat {
        static let FileNotFound = "Couldn't find %@ in main bundle."
        static let FileCanNotLoad = "Couldn't load %@ from main bundle:\n%@"
        static let FileDecodeFail = "Couldn't parse %@ as %@:\n%@"
    }
    
    static let JSONDecoder: Foundation.JSONDecoder = {
        let decoder = Foundation.JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingFormatters = [.SlashStyle, .DashStyle]
        return decoder
    }()
}

extension DateFormatter {
    static let SlashStyle: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()
    
    static let DashStyle: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}

extension JSONDecoder {
    var dateDecodingFormatters: [DateFormatter]? {
        get { return nil }
        set {
            guard let formatters = newValue else { return }
            self.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }
                return Date.invalid
            }
        }
    }
}

extension Date {
    // The distancePast display text is "0001/01/01", which is an invalid date replacement since we must return non optional date in dateDecodingStrategy. The `Animal` model raw constructor will fix it to optional `Date`.
    static var invalid: Date { .distantPast }
}
