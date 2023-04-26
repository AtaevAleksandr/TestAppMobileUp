//
//  PhotosFeedModels.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum PhotosFeed {

    enum Model {
        struct Request {
            enum RequestType {
                case getPhoto
            }
        }
        struct Response {
            enum ResponseType {
                case presentPhoto(photo: Album)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayPhoto(photoViewModel: PhotoViewModel)
            }
        }
    }
}
struct PhotoViewModel {
    struct Cell: PhotoCellViewModel {
        var photoAttachment: PhotoAlbumViewModel?
    }

    struct PhotoCellPhotoAlbum: PhotoAlbumViewModel {
        var photoUrlString: String?
        var height: Int
        var width: Int
    }

    let cells: [Cell]
}
