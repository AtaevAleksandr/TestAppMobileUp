//
//  PhotosFullScreenViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 26.04.2023.
//

import UIKit

class PhotosFullScreenViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createNavBarItems()
        view.addSubview(photosFullScreen)
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK: - Clouser
    lazy var photosFullScreen: WebImageView = {
        let image = WebImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(systemName: "circle.dashed")
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 0.5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    //MARK: - Methods
    private func createNavBarItems() {

        let navigationRightButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveImage))
        self.navigationItem.rightBarButtonItem = navigationRightButton

        let navigationBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(navigationBackButton, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photosFullScreen.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photosFullScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func set(viewModel: PhotoCellViewModel) {
        if let photoAttachment = viewModel.photoAttachment {
            photosFullScreen.set(imageURL: photoAttachment.photoUrlString)
        }
    }

    @objc func saveImage(sender: UIBarButtonItem) {
        print("Save")
    }

    @objc func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

