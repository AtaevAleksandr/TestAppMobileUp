//
//  AuthServices.swift
//  TestAppMobileUp
//
//  Created by Aleksandr Ataev on 24.04.2023.
//

import Foundation
import vk_ios_sdk

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSighIn()
    func authServiceSighInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    private let appId = "51625050"
    private let vkSdk: VKSdk

    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }

    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken().accessToken
    }

    func wakeUpSession() {
        let scope = ["friends","photos", "video", "status", "wall", "offline", "groups", "stats","email"]
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            switch state {
            case .initialized:
                VKSdk.authorize(scope)
            case .authorized:
                delegate?.authServiceSighIn()
            default:
                delegate?.authServiceSighInDidFail()
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
