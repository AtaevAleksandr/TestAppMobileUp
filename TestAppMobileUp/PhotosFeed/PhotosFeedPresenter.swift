//
//  PhotosFeedPresenter.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedPresentationLogic {
    func presentData(response: PhotosFeed.Model.Response.ResponseType)
}

class PhotosFeedPresenter: PhotosFeedPresentationLogic {
    weak var viewController: PhotosFeedDisplayLogic?

//    var photos = [PhotoInfo]()
//    var photoLinks = [String]()
//    var photoDates = [String]()

    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm "
        return dt
    }()

    func presentData(response: PhotosFeed.Model.Response.ResponseType) {

        switch response {
        case .presentPhoto(photo: let photo):
            let cells = photo.items.map { (photoItem) in
                cellViewModel(from: photoItem)
            }
            let photoViewModel = PhotoViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayPhoto(photoViewModel: photoViewModel))
        }

    }

    private func cellViewModel(from photoItem: PhotoItem) -> PhotoViewModel.Cell {

//        self.photos = photoItem.sizes
//        for i in 0..<self.photos.count {
//            let photo = self.photos[i]
//            if photo.type == "z" {
//                let urlString = photo.url
//                self.photoLinks.append(urlString)
//            }
//        }
        if photoItem.sizes[0].type == "z" {
            let urlString = photoItem.sizes[0].url
        }
        return PhotoViewModel.Cell.init(imageUrlString: photoItem.sizes[0].url)
    }

}
