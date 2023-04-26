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

    private func cellViewModel(from albumItem: AlbumInfo) -> PhotoViewModel.Cell {

        let photoAttachment = self.photoAlbum(photoItem: albumItem)

        return PhotoViewModel.Cell.init(photoAttachment: photoAttachment)
    }

    private func photoAlbum(photoItem: AlbumInfo) -> PhotoViewModel.PhotoCellPhotoAlbum? {
        return PhotoViewModel.PhotoCellPhotoAlbum.init(photoUrlString: photoItem.srcBIG, height: photoItem.height, width: photoItem.width, date: photoItem.date)
    }
}
