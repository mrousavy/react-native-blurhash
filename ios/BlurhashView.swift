//
//  BlurhashView.swift
//  Blurhash
//
//  Created by Marc Rousavy on 15.06.20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol BlurhashViewDelegate {
    func blurhashViewLoadDidStart()
    func blurhashViewLoadDidEnd()
    func blurhashViewLoadDidError(_ message: String?)
}

public final class BlurhashView: UIView {
    @objc public var blurhash: String?
    @objc public var decodeWidth: Int = 32
    @objc public var decodeHeight: Int = 32
    @objc public var decodePunch: Float = 1
    @objc public var decodeAsync: Bool = false
    @objc override public var contentMode: ContentMode {
        get {
            imageContainer.contentMode
        }
        set {
            imageContainer.contentMode = newValue
        }
    }

    @objc public weak var delegate: BlurhashViewDelegate?

    private var lastState: BlurhashCache?
    private let imageContainer: UIImageView

    override public init(frame: CGRect) {
        imageContainer = UIImageView()
        imageContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageContainer.clipsToBounds = true
        imageContainer.contentMode = .scaleAspectFill
        super.init(frame: frame)
        addSubview(imageContainer)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private final func renderBlurhash() {
        do {
            emitLoadStartEvent()
            guard let blurhash = blurhash else {
                throw BlurhashError.invalidBlurhashString(isNil: true)
            }
            guard decodeWidth > 0 else {
                throw BlurhashError.invalidBlurhashDecodeWidth(actualValue: decodeWidth)
            }
            guard decodeHeight > 0 else {
                throw BlurhashError.invalidBlurhashDecodeHeight(actualValue: decodeHeight)
            }
            guard decodePunch > 0 else {
                throw BlurhashError.invalidBlurhashDecodePunch(actualValue: decodePunch)
            }

            let size = CGSize(width: decodeWidth, height: decodeHeight)
            let nullableImage = UIImage(blurHash: blurhash, size: size, punch: decodePunch)
            guard let image = nullableImage else {
                throw BlurhashError.invalidBlurhashString(isNil: false)
            }
            setImageContainerImage(image: image)
            emitLoadEndEvent()
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
            emitLoadErrorEvent(message: "An unknown error occured while trying to decode the blurhash!")
        }
        // Called if Error was thrown: Set image to nil to clear the outdated Blurhash
        setImageContainerImage(image: nil)
    }

    @objc
    public final func finalizeUpdates() {
        let shouldReRender = self.shouldReRender()
        if shouldReRender {
            if decodeAsync {
                DispatchQueue.global(qos: .userInteractive).async {
                    self.renderBlurhash()
                }
            } else {
                renderBlurhash()
            }
        }
    }

    private final func shouldReRender() -> Bool {
        defer {
            self.lastState = BlurhashCache(blurhash: self.blurhash, decodeWidth: self.decodeWidth, decodeHeight: self.decodeHeight, decodePunch: self.decodePunch)
        }
        guard let lastState = lastState else {
            return true
        }
        guard let blurhash = blurhash else {
            return true
        }
        return lastState.isDifferent(blurhash: blurhash, decodeWidth: decodeWidth, decodeHeight: decodeHeight, decodePunch: decodePunch)
    }

    private final func setImageContainerImage(image: UIImage?) {
        if Thread.isMainThread {
            imageContainer.image = image
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
        delegate?.blurhashViewLoadDidError(message)
    }

    private final func emitLoadStartEvent() {
        delegate?.blurhashViewLoadDidStart()
    }

    private final func emitLoadEndEvent() {
        delegate?.blurhashViewLoadDidEnd()
    }
}
