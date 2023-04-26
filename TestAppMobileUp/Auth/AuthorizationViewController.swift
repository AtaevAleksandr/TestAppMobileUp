//
//  AuthorizationViewController.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 21.04.2023.
//

import UIKit

final class AuthorizationViewController: UIViewController {

    //MARK: - Properties
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
        view.backgroundColor = UIColor(named: "backgroundColor")
        [nameLabel, authButton].forEach { view.addSubview($0) }
        setConstraints()
    }
    
    //MARK: - Clousers
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Up\nGallery"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Вход через VK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapToAuthorization), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 82),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -124),
            
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc private func tapToAuthorization() {
        authService.wakeUpSession()
    }
}
