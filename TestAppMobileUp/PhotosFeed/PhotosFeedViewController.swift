//
//  PhotosFeedViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 25.04.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import vk_ios_sdk

protocol PhotosFeedDisplayLogic: AnyObject {
    func displayData(viewModel: PhotosFeed.Model.ViewModel.ViewModelData)
}

class PhotosFeedViewController: UIViewController, PhotosFeedDisplayLogic {

    var interactor: PhotosFeedBusinessLogic?
    var router: (NSObjectProtocol & PhotosFeedRoutingLogic)?

    private var photoViewModel = PhotoViewModel.init(cells: [])

    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Setup
    private func setup() {
        let viewController        = self
        let interactor            = PhotosFeedInteractor()
        let presenter             = PhotosFeedPresenter()
        let router                = PhotosFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    // MARK: - Routing

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        view.addSubview(photosCollectionView)
        createNavBarItems()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        setConstraints()
        interactor?.makeRequest(request: .getPhoto)
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

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func displayData(viewModel: PhotosFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhoto(photoViewModel: let photoViewModel):
            self.photoViewModel = photoViewModel
            photosCollectionView.reloadData()
        }
    }
}

extension PhotosFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoViewModel.cells.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 193, height: 186)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseId, for: indexPath) as! PhotosCollectionViewCell
        let cellViewModel = photoViewModel.cells[indexPath.item]
        cell.set(viewModel: cellViewModel)
        
//        fetcher.getResponse { (response) in
//            guard let response = response else { return }
//            for item in response.items {
//                self.photos = item.sizes
//                for i in 0..<self.photos.count {
//                    let photo = self.photos[i]
//                    if photo.type == "z" {
//                        let urlString = photo.url
//                        self.photoLinks.append(urlString)
//                    }
//                }
//                let date = Date(timeIntervalSince1970: item.date)
//                let dateTitle = self.dateFormatter.string(from: date)
//                self.photoDates.append(dateTitle)
//            }
//            cell.imageView.downloaded(from: self.photoLinks[indexPath.row])
//        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select row")
        collectionView.deselectItem(at: indexPath, animated: false)
        interactor?.makeRequest(request: .getPhoto)
        //        delegate?.didChoosePhoto(urlString: photoLinks[indexPath.row], date: photoDates[indexPath.row])
        //        let photoVC = PhotoViewController()
        //        photoVC.photoImageURL = photoLinks[indexPath.row]
        //        photoVC.photoImageDate = photoDates[indexPath.row]
        //        photoVC.dateFormatter = dateFormatter
        //        navigationController?.pushViewController(photoVC, animated: true)
    }
}