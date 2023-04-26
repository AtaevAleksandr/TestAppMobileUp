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

    var photoViewModel = PhotoViewModel.init(cells: [])

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
        photosCollectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    //MARK: - Methods
    private func createNavBarItems() {
        navigationItem.title = "MobileUp Gallery"

        let navigationRightButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(exitVK))
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
        return CGSize(width: (UIScreen.main.bounds.width - 6) / 2, height: 186)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseId, for: indexPath) as! PhotosCollectionViewCell
        let cellViewModel = photoViewModel.cells[indexPath.item]
        cell.set(viewModel: cellViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let selectionCellViewModel = photoViewModel.cells[indexPath.item]
        let date = Date(timeIntervalSince1970: TimeInterval(selectionCellViewModel.photoAttachment?.date ?? 0.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy 'в' HH:mm"
        let dateString = dateFormatter.string(from: date)
        let vc = PhotosFullScreenViewController()
        vc.photosFullScreen.set(imageURL: selectionCellViewModel.photoAttachment?.photoUrlString)
        vc.navigationItem.title = dateString
        navigationController?.pushViewController(vc, animated: true)
    }
}
