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
  
  }
  
}
