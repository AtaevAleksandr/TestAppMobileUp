//
//  NetworkDataFetcher.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//

import Foundation

protocol DataFetcher {
    func getResponse(response: @escaping (PhotoResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {

    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getResponse(response: @escaping (PhotoResponse?) -> Void) {
        let parameters = ["owner_id": "-128666765", "album_id": "266310117"]
        networking.request(path: API.photosGet, parameters: parameters) { (data, error) in
            if let error = error {
                print("error while receiving data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: PhotoResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }

    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
