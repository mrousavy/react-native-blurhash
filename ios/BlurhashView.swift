//
//  BlurhashView.swift
//  Blurhash
//
//  Created by Marc Rousavy on 15.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

final class BlurhashView: UIView {
    @objc var blurhash: NSString?
    @objc var decodeWidth: NSNumber = 32
    @objc var decodeHeight: NSNumber = 32
    @objc var decodePunch: NSNumber = 1
    @objc var decodeAsync: Bool = false

    @objc var resizeMode: NSString = "cover"

    @objc var onLoadStart: RCTDirectEventBlock?
    @objc var onLoadEnd: RCTDirectEventBlock?
    @objc var onLoadError: RCTDirectEventBlock?

    private var lastState: BlurhashCache?
    private let imageContainer: UIImageView

    override init(frame: CGRect) {
        self.imageContainer = UIImageView()
        self.imageContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageContainer.clipsToBounds = true
        self.imageContainer.contentMode = .scaleAspectFill
        super.init(frame: frame)
        self.addSubview(self.imageContainer)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private final func renderBlurhash() {
        do {
            self.emitLoadStartEvent()
            guard let blurhash = self.blurhash else {
                throw BlurhashError.invalidBlurhashString(isNil: true)
            }
            guard self.decodeWidth.intValue > 0 else {
                throw BlurhashError.invalidBlurhashDecodeWidth(actualValue: self.decodeWidth.intValue)
            }
            guard self.decodeHeight.intValue > 0 else {
                throw BlurhashError.invalidBlurhashDecodeHeight(actualValue: self.decodeHeight.intValue)
            }
            guard self.decodePunch.floatValue > 0 else {
                throw BlurhashError.invalidBlurhashDecodePunch(actualValue: self.decodePunch.floatValue)
            }

            let size = CGSize(width: decodeWidth.intValue, height: self.decodeHeight.intValue)
            let nullableImage = UIImage(blurHash: blurhash as String, size: size, punch: self.decodePunch.floatValue)
            guard let image = nullableImage else {
                throw BlurhashError.invalidBlurhashString(isNil: false)
            }
            self.setImageContainerImage(image: image)
            self.emitLoadEndEvent()
            return
        } catch let BlurhashError.decodeError(message) {
            emitLoadErrorEvent(message: message)
        } catch let BlurhashError.invalidBlurhashString(isNil) {
            emitLoadErrorEvent(message: isNil ? "The provided Blurhash string must not be null!" : "The provided Blurhash string was invalid.")
        } catch let BlurhashError.invalidBlurhashDecodeWidth(actualValue) {
            emitLoadErrorEvent(message: "decodeWidth must be greater than 0! Actual: \(actualValue)")
        } catch let BlurhashError.invalidBlurhashDecodeHeight(actualValue) {
            emitLoadErrorEvent(message: "decodeHeight must be greater than 0! Actual: \(actualValue)")
        } catch let BlurhashError.invalidBlurhashDecodePunch(actualValue) {
            emitLoadErrorEvent(message: "decodePunch must be greater than 0! Actual: \(actualValue)")
        } catch {
            self.emitLoadErrorEvent(message: "An unknown error occured while trying to decode the blurhash!")
        }
        // Called if Error was thrown: Set image to nil to clear the outdated Blurhash
        self.setImageContainerImage(image: nil)
    }

    override final func didSetProps(_ changedProps: [String]!) {
        let shouldReRender = self.shouldReRender()
        if shouldReRender {
            if self.decodeAsync {
                DispatchQueue.global(qos: .userInteractive).async {
                    self.renderBlurhash()
                }
            } else {
                self.renderBlurhash()
            }
        }
        if changedProps.contains("resizeMode") {
            self.updateImageContainer()
        }
    }

    private final func shouldReRender() -> Bool {
        defer {
            self.lastState = BlurhashCache(blurhash: self.blurhash, decodeWidth: self.decodeWidth, decodeHeight: self.decodeHeight, decodePunch: self.decodePunch)
        }
        guard let lastState = self.lastState else {
            return true
        }
        guard let blurhash = self.blurhash else {
            return true
        }
        return lastState.isDifferent(blurhash: blurhash, decodeWidth: self.decodeWidth, decodeHeight: self.decodeHeight, decodePunch: self.decodePunch)
    }

    private final func updateImageContainer() {
        self.imageContainer.contentMode = self.parseResizeMode(resizeMode: self.resizeMode)
    }

    private final func setImageContainerImage(image: UIImage?) {
        if Thread.isMainThread {
            self.imageContainer.image = image
        } else {
            DispatchQueue.main.async {
                self.imageContainer.image = image
            }
        }
    }

    private final func emitLoadErrorEvent(message: String?) {
        if let message = message {
            log(level: .error, message: message)
        }
        if let onLoadError = self.onLoadError {
            onLoadError(["message": message as Any])
        }
    }

    private final func emitLoadStartEvent() {
        if let onLoadStart = self.onLoadStart {
            onLoadStart(nil)
        }
    }

    private final func emitLoadEndEvent() {
        if let onLoadEnd = self.onLoadEnd {
            onLoadEnd(nil)
        }
    }

    private final func parseResizeMode(resizeMode: NSString) -> ContentMode {
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
}
