//
//  NetworkService.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import Foundation

final class NetworkService {

    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }

    func getPhotos() {
        var components = URLComponents()

        guard let token = authService.token else { return }
        let params = ["album_id": "wall,profile"]
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version

        components.scheme = API.scheme
        components.host = API.host
        components.path = API.photosGet
        components.queryItems = allParams.map { URLQueryItem(name: $0, value: $1) }

        let url = components.url!
        print(url)
    }
}
