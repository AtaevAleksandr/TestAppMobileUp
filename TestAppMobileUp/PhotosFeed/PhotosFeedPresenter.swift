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

    private func cellViewModel(from photoItem: PhotoItem) -> PhotoViewModel.Cell {
        return PhotoViewModel.Cell.init(imageUrlString: "")
    }
  
}
