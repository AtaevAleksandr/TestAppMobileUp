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
    var isSuccess: Bool!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    lazy var imageView: WebImageView = {
        let image = WebImageView()
        image.tintColor = .systemGray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.startAnimating()
        return image
    }()

    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor(red: 74 / 255, green: 35 / 255, blue: 245 / 255, alpha: 1.0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    func set(viewModel: PhotoCellViewModel) {
        if let photoAttachment = viewModel.photoAttachment {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.imageView.set(imageURL: photoAttachment.photoUrlString)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
}
