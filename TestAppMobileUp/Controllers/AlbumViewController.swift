//
//  AlbumViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import UIKit
import vk_ios_sdk

protocol PhotoSelectionDelegate {
    func didChoosePhoto(urlString: String, date: String)
}

class AlbumViewController: UIViewController {

    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    var delegate: PhotoSelectionDelegate?

    var photos = [PhotoInfo]()
    var photoLinks = [String]()
    var photoDates = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createNavBarItems()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        view.addSubview(photosCollectionView)
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    struct Cell {
        static let photosCollectionCell = "PhotosCollectionViewCell"
    }

    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMMM YYYY"
        return dt
    }()

    //MARK: - Methods
    private func createNavBarItems() {
        navigationItem.title = "MobileUp Gallery"


        let navigationRightButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(exitVK))
        navigationRightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = navigationRightButton
    }

    @objc func exitVK(sender: UIBarButtonItem) {
        VKSdk.forceLogout()
        let vc = AuthorizationViewController()
        navigationController?.pushViewController(vc, animated: true)

    }

    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.itemSize = CGSize(width: 192, height: 186)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: Cell.photosCollectionCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.photosCollectionCell, for: indexPath) as! PhotosCollectionViewCell
        fetcher.getResponse { (response) in
            guard let response = response else { return }
            for item in response.items {
                self.photos = item.sizes
                for x in 0..<self.photos.count {
                    let photo = self.photos[x]
                    if photo.type == "z" {
                        let urlString = photo.url
                        self.photoLinks.append(urlString)
                    }
                }
                let date = Date(timeIntervalSince1970: item.date)
                let dateTitle = self.dateFormatter.string(from: date)
                self.photoDates.append(dateTitle)
            }
            item.imageView.downloaded(from: self.photoLinks[indexPath.item])
        }
        return item
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        delegate?.didChoosePhoto(urlString: photoLinks[indexPath.row], date: photoDates[indexPath.row])
//        let photoVC = PhotoViewController()
//        photoVC.photoImageURL = photoLinks[indexPath.row]
//        photoVC.photoImageDate = photoDates[indexPath.row]
//        photoVC.dateFormatter = dateFormatter
//        navigationController?.pushViewController(photoVC, animated: true)
//    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
