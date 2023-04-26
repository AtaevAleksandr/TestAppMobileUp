//
//  WebImageView.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//

import Foundation
import UIKit

class WebImageView: UIImageView {

    private var currentUrlSrting: String?

    func set(imageURL: String?) {
        currentUrlSrting = imageURL

        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)

                }
            }
        }
        dataTask.resume()
    }

    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))

        if responseURL.absoluteString == currentUrlSrting {
            self.image = UIImage(data: data)
        }
    }
}
