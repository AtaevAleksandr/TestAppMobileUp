//
//  PhotosFullScreenViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 26.04.2023.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
}

class PhotosFullScreenViewController: UIViewController, UIGestureRecognizerDelegate, PhotosFeedDisplayLogic {

    var interactor: PhotosFeedBusinessLogic?
    var router: (NSObjectProtocol & PhotosFeedRoutingLogic)?
    var photoViewModel = PhotoViewModel.init(cells: [])
    var originalTransform: CGAffineTransform!
    var lastLocation = CGPoint.zero

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
        router.vc     = viewController
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setup()
        createNavBarItems()
        [photosFullScreen, feedCollectionView].forEach { view.addSubview($0) }
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        setConstraints()
        interactor?.makeRequest(request: .getPhoto)
        originalTransform = photosFullScreen.transform
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor(named: "otherColor")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Clouser
    lazy var photosFullScreen: WebImageView = {
        let image = WebImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "circle.dashed")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .systemGray
        image.backgroundColor = UIColor(named: "backgroundColor")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomPhoto))
        image.addGestureRecognizer(pinchGesture)
        return image
    }()

    private lazy var feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    //MARK: - Methods
    private func createNavBarItems() {

        let navigationRightButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareSheetToSaveImage))
        self.navigationItem.rightBarButtonItem = navigationRightButton

        let navigationBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(navigationBackButton, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photosFullScreen.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photosFullScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photosFullScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosFullScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosFullScreen.heightAnchor.constraint(equalToConstant: 375),

            feedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedCollectionView.heightAnchor.constraint(equalToConstant: 54),
            feedCollectionView.widthAnchor.constraint(equalToConstant: 54)
        ])
    }

    func displayData(viewModel: PhotosFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhoto(photoViewModel: let photoViewModel):
            self.photoViewModel = photoViewModel
            feedCollectionView.reloadData()
        }
    }

    @objc func shareSheetToSaveImage(_ sender: UIBarButtonItem) {
        guard let image = photosFullScreen.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            if completed && activityType == .saveToCameraRoll {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }

    func showAlert() {
        let alert = UIAlertController(title: "Success!", message: "You have saved the photo.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @objc func zoomPhoto(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }

        if gesture.state == .began {
            view.transform = originalTransform.scaledBy(x: gesture.scale, y: gesture.scale)
        } else if gesture.state == .changed {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        } else if gesture.state == .ended || gesture.state == .cancelled {
            UIView.animate(withDuration: 0.5) {
                view.transform = self.originalTransform
            }
        }
    }
}

extension PhotosFullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoViewModel.cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseId, for: indexPath) as! PhotosCollectionViewCell
        let cellViewModel = photoViewModel.cells[indexPath.item]
        cell.set(viewModel: cellViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photoViewModel.cells[indexPath.item]
        photosFullScreen.set(imageURL: selectedPhoto.photoAttachment?.photoUrlString)
    }
}

