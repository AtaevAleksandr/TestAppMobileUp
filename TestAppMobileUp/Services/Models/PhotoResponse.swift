//
//  PhotoResponse.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//

import Foundation

struct PhotoResponseWrapped: Decodable {
    let response: PhotoResponse
}

struct PhotoResponse: Decodable {
    var items: [AlbumInfo]
}

struct AlbumInfo: Decodable {
    let date: Double
    let sizes: [PhotoInfo]
}

struct PhotoInfo: Decodable {
    let url: String
    var type: String
}
