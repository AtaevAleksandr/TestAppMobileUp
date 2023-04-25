//
//  PhotosFeedInteractor.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhotosFeedBusinessLogic {
  func makeRequest(request: PhotosFeed.Model.Request.RequestType)
}

class PhotosFeedInteractor: PhotosFeedBusinessLogic {

  var presenter: PhotosFeedPresentationLogic?
  var service: PhotosFeedService?
  
  func makeRequest(request: PhotosFeed.Model.Request.RequestType) {
    if service == nil {
      service = PhotosFeedService()
    }
  }
  
}
