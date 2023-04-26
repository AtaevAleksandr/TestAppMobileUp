//
//  PhotosFullScreenViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 26.04.2023.
//

import UIKit

class PhotosFullScreenViewController: UIViewController, UIGestureRecognizerDelegate {

    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    var photoImageURL: String?
    var photoImageDate: String?
    var photos = [PhotoSize]()
    var photoLinks = [String]()
    var photoDates = [String]()
    var dateFormatter: DateFormatter?

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createNavBarItems()
        view.addSubview(photosFullScreen)
        photosFullScreen.downloaded(from: photoImageURL ?? "")
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    //MARK: - Clouser
    lazy private var photosFullScreen: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(systemName: "circle.dashed")
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    //MARK: - Methods
    private func createNavBarItems() {
        navigationItem.title = photoImageDate

        let navigationRightButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveImage))
        self.navigationItem.rightBarButtonItem = navigationRightButton

        let navigationBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(back))
        self.navigationItem.setLeftBarButton(navigationBackButton, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photosFullScreen.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photosFullScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func saveImage(sender: UIBarButtonItem) {
        printContent("Save")
    }

    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension PhotosFullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosFullScreenCollectionViewCell.reuseId, for: indexPath) as! PhotosFullScreenCollectionViewCell

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
                let dateTitle = self.dateFormatter!.string(from: date)
                self.photoDates.append(dateTitle)
            }
            cell.photosFullScreen.downloaded(from: self.photoLinks[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let layout = collectionViewLayout as? UICollectionViewFlowLayout

        layout?.scrollDirection = .horizontal
        layout!.minimumInteritemSpacing = 2.0
        layout!.minimumLineSpacing = 0.0

        let sideSize: CGFloat = 56
        return CGSize(width: sideSize, height: sideSize)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
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
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

