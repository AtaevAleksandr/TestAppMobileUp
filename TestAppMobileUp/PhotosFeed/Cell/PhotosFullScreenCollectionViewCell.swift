//
//  PhotosFullScreenCollectionViewCell.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 26.04.2023.
//

import UIKit

class PhotosFullScreenCollectionViewCell: UICollectionViewCell {

    static let reuseId = "PhotosFullScreenCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
