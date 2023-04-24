//
//  AlbumViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import UIKit
import vk_ios_sdk

class AlbumViewController: UIViewController {

    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createNavBarItems()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        view.addSubview(photosCollectionView)
        setConstraints()
        networkService.getPhotos()
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
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 10) / 2, height: 160)

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
        return item
    }
}
