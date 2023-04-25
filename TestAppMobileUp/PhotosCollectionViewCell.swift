//
//  PhotosCollectionViewCell.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemMint
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
