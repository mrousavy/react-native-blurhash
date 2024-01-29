//
//  BlurhashViewManager.swift
//  Blurhash
//
//  Created by Marc Rousavy on 08.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

final class BlurhashViewWrapper: UIView, BlurhashViewDelegate {
    private var blurhashView: BlurhashView

    @objc var blurhash: NSString? {
        get {
            blurhashView.blurhash as NSString?
        }
        set {
            blurhashView.blurhash = newValue as String?
        }
    }

    @objc var decodeWidth: NSNumber {
        get {
            blurhashView.decodeWidth as NSNumber
        }
        set {
            blurhashView.decodeWidth = newValue.intValue
        }
    }

    @objc var decodeHeight: NSNumber {
        get {
            blurhashView.decodeHeight as NSNumber
        }
        set {
            blurhashView.decodeHeight = newValue.intValue
        }
    }

    @objc var decodePunch: NSNumber {
        get {
            blurhashView.decodePunch as NSNumber
        }
        set {
            blurhashView.decodePunch = newValue.floatValue
        }
    }

    @objc var decodeAsync: Bool {
        get {
            blurhashView.decodeAsync
        }
        set {
            blurhashView.decodeAsync = newValue
        }
    }

    @objc var resizeMode: NSString {
        get {
            convertContentMode(resizeMode: blurhashView.contentMode)
        }
        set {
            blurhashView.contentMode = convertResizeMode(resizeMode: newValue)
        }
    }

    @objc var onLoadStart: RCTDirectEventBlock?
    @objc var onLoadEnd: RCTDirectEventBlock?
    @objc var onLoadError: RCTDirectEventBlock?

    override public init(frame: CGRect) {
        blurhashView = BlurhashView(frame: frame)

        super.init(frame: frame)

        blurhashView.delegate = self
        addSubview(blurhashView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reactSetFrame(_ frame: CGRect) {
        blurhashView.frame = frame
    }

    override func didSetProps(_: [String]!) {
        blurhashView.finalizeUpdates()
    }

    func blurhashViewLoadDidStart() {
        onLoadStart?(nil)
    }

    func blurhashViewLoadDidEnd() {
        onLoadEnd?(nil)
    }

    func blurhashViewLoadDidError(_ message: String?) {
        onLoadError?(["message": message as Any])
    }

    private final func convertResizeMode(resizeMode: NSString) -> ContentMode {
        switch resizeMode {
        case "contain":
            return .scaleAspectFit
        case "cover":
            return .scaleAspectFill
        case "stretch":
            return .scaleToFill
        case "center":
            return .center
        default:
            return .scaleAspectFill
        }
    }

    private final func convertContentMode(resizeMode: ContentMode) -> NSString {
        switch resizeMode {
        case .scaleAspectFit:
            return "contain"
        case .scaleAspectFill:
            return "cover"
        case .scaleToFill:
            return "stretch"
        case .center:
            return "center"
        default:
            return "cover"
        }
    }
}

@objc(BlurhashViewManager)
final class BlurhashViewManager: RCTViewManager {
    override final func view() -> UIView! {
        return BlurhashViewWrapper()
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
