//
//  ToastNotificationManager.swift
//  InfiniteScroll
//
//  Created by Dmitrii Coolerov on 24.03.2022.
//

import Foundation
import SwiftMessages
import UIKit

public enum ToastNotificationType {
    case success(message: String)
    case failure(message: String)
    case info(title: String, message: String)
    case danger(title: String, message: String)
}

public protocol ToastNotificationManagerProtocol: AnyObject {
    func showNotification(with type: ToastNotificationType)
}

public final class ToastNotificationManager: ToastNotificationManagerProtocol {
    private struct Constants {
        let errorColor = UIColor(red: 0.9, green: 0.31, blue: 0.26, alpha: 1)
        let successColor = UIColor(red: 0.22, green: 0.8, blue: 0.46, alpha: 1)
        let infoColor = UIColor(red: 0.23, green: 0.6, blue: 0.85, alpha: 1)
    }

    private let constants = Constants()

    private let swiftMessages = SwiftMessages()

    public init() {}

    private var appWindow: UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .map { $0 as? UIWindowScene }
            .flatMap { $0?.windows.first } ?? UIApplication.shared.delegate?.window
        return window ?? nil
    }

    public func showNotification(with type: ToastNotificationType) {
        switch type {
        case let .success(message):
            let status = MessageView.viewFromNib(layout: .statusLine)
            status.backgroundView.backgroundColor = constants.successColor
            status.bodyLabel?.textColor = UIColor.white
            status.configureContent(body: message)
            var statusConfig = SwiftMessages.defaultConfig
            statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            statusConfig.preferredStatusBarStyle = .lightContent

            swiftMessages.show(config: statusConfig, view: status)

        case let .failure(message):
            let status = MessageView.viewFromNib(layout: .statusLine)
            status.backgroundView.backgroundColor = constants.errorColor
            status.bodyLabel?.textColor = UIColor.white
            status.configureContent(body: message)
            var statusConfig = SwiftMessages.defaultConfig
            statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            statusConfig.preferredStatusBarStyle = .lightContent

            swiftMessages.show(config: statusConfig, view: status)

        case let .info(title, message):
            let warning = MessageView.viewFromNib(layout: .cardView)
            let iconImage = IconStyle.default.image(theme: .info)
            warning.configureTheme(backgroundColor: .white, foregroundColor: .black, iconImage: iconImage)
            warning.iconImageView?.tintColor = constants.infoColor
            warning.configureDropShadow()

            warning.configureContent(title: title, body: message)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            warningConfig.presentationStyle = .bottom

            swiftMessages.show(config: warningConfig, view: warning)

        case let .danger(title, message):
            let warning = MessageView.viewFromNib(layout: .cardView)
            let iconImage = IconStyle.default.image(theme: .error)
            warning.configureTheme(backgroundColor: .white, foregroundColor: .black, iconImage: iconImage)
            warning.iconImageView?.tintColor = constants.errorColor
            warning.configureDropShadow()

            warning.configureContent(title: title, body: message)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            warningConfig.presentationStyle = .bottom

            swiftMessages.show(config: warningConfig, view: warning)
        }
    }

    private func topViewController(in viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return topViewController(in: presentedViewController)
        } else if let parentViewController = viewController.parent {
            return topViewController(in: parentViewController)
        } else {
            return viewController
        }
    }
}
