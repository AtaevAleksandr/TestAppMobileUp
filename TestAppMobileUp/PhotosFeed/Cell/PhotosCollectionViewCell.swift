//
//  PhotosCollectionViewCell.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import UIKit

protocol PhotoCellViewModel {
    var photoAttachment: PhotoAlbumViewModel? { get }
}

protocol PhotoAlbumViewModel {
    var photoUrlString: String? { get }
    var height: Int { get }
    var width: Int { get }
    var date: Double { get }
}

class PhotosCollectionViewCell: UICollectionViewCell {

    static let reuseId = "PhotosCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    lazy var imageView: WebImageView = {
        let image = WebImageView()
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.5
        image.image = UIImage(systemName: "circle.dashed")
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func set(viewModel: PhotoCellViewModel) {
        if let photoAttachment = viewModel.photoAttachment {
            imageView.set(imageURL: photoAttachment.photoUrlString)
        }
    }
}
