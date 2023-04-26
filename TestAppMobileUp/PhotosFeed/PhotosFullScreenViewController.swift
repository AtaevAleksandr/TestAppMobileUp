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

class PhotosFullScreenViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        createNavBarItems()
        view.addSubview(photosFullScreen)
        setConstraints()
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
        image.contentMode = .scaleToFill
        image.image = UIImage(systemName: "circle.dashed")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .systemGray
        image.backgroundColor = UIColor(named: "backgroundColor")
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
            photosFullScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photosFullScreen.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])
    }

    func set(viewModel: PhotoCellViewModel) {
        if let photoAttachment = viewModel.photoAttachment {
            photosFullScreen.set(imageURL: photoAttachment.photoUrlString)
        }
    }

    @objc func saveImage(sender: UIBarButtonItem) {
        let items: [Any] = [UIImageView()]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

        guard let image = photosFullScreen.image else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: image)
        showAlert()
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
}

