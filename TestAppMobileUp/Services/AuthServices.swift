//
//  AuthServices.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import Foundation
import vk_ios_sdk
import WebKit

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSighIn()
    func authServiceSighInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate, WKNavigationDelegate {

    private let appId = "51625050"
    private let vkSdk: VKSdk

    // kursantataev@mail.ru
    // onlySan4ez

    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }

    weak var delegate: AuthServiceDelegate?

    func wakeUpSession() {
        let scope = ["offline"]
        VKSdk.wakeUpSession(scope) { (state, error) in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .webview:
                print("webview")
            case .authorized:
                print("authorized")
            default:
                fatalError(error!.localizedDescription)
            }
        }
    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSighIn()
        }
    }

    func vkSdkUserAuthorizationFailed() {
        delegate?.authServiceSighInDidFail()
    }

    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(viewController: controller)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }

}
