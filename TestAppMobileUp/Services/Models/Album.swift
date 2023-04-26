//
//  PhotoResponse.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: Album
}

struct Album: Decodable {
    var items: [AlbumInfo]
}

struct AlbumInfo: Decodable {
    let date: Double
    let sizes: [PhotoSize]

    var height: Int {
        return getPropperSize().height
    }

    var width: Int {
        return getPropperSize().width
    }

    var srcBIG: String {
        return getPropperSize().url
    }

    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize.init(url: "wrong image", type: "wrong image", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let url: String
    var type: String
    let width: Int
    let height: Int
}
