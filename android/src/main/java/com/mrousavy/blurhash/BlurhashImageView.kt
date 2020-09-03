package com.mrousavy.blurhash

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


internal class BlurhashCache(private val _blurhash: String?, private val _decodeWidth: Int, private val _decodeHeight: Int, private val _decodePunch: Float) {
    fun isDifferent(blurhash: String?, decodeWidth: Int, decodeHeight: Int, decodePunch: Float): Boolean {
        return !safeStringEquals(_blurhash, blurhash) || _decodeWidth != decodeWidth || _decodeHeight != decodeHeight || _decodePunch != decodePunch
    }

    private fun safeStringEquals(left: String?, right: String?): Boolean {
        return when {
            left == null -> {
                // left: null and right: null
                right == null
            }
            right == null -> {
                // left: not null and right: null
                false
            }
            else -> {
                // left: not null and right: not null
                left == right
            }
        }
    }

}

class BlurhashImageView(context: Context?): androidx.appcompat.widget.AppCompatImageView(context) {
    var blurhash: String? = null
    var decodeWidth = 32
    var decodeHeight = 32
    var decodePunch = 1.0f
    var decodeAsync = false
    private var _cachedBlurhash: BlurhashCache? = null
    private var _mainThreadId = Thread.currentThread().id
    private var _bitmap: Bitmap? = null

    private fun getThreadDescriptor(): String {
        return if (Thread.currentThread().id == this._mainThreadId) "main"
        else "separate"
    }

    private fun renderBlurhashForReal() {
        try {
            val useCache = true
            log("Decoding ${decodeWidth}x${decodeHeight} blurhash ($blurhash) on ${getThreadDescriptor()} Thread!")
            _bitmap = BlurHashDecoder.decode(blurhash, decodeWidth, decodeHeight, decodePunch, useCache)
            setImageBitmap(_bitmap)
            emitBlurhashLoadEnd()
        } catch (e: Exception) {
            emitBlurhashLoadError(e.message)
        }
    }

    private fun renderBlurhash(decodeAsync: Boolean) {
        // TODO: Disable Blurhash cache? I'm caching anyways..
        emitBlurhashLoadStart()
        if (decodeWidth > 0 && decodeHeight > 0 && decodePunch > 0) {
            if (decodeAsync) {
                GlobalScope.launch {
                    renderBlurhashForReal()
                }
            } else {
                renderBlurhashForReal()
            }
        } else {
            warn("decodeWidth, decodeHeight and decodePunch properties of Blurhash View must be greater than 0!")
            setImageBitmap(null)
        }
    }

    fun updateBlurhash() {
        val shouldReRender = this.shouldReRender()
        RNLog.l("Should re-render: $shouldReRender")
        if (shouldReRender) {
            renderBlurhash(this.decodeAsync)
        }
    }

    fun redraw() {
        setImageBitmap(_bitmap)
    }

    private fun shouldReRender(): Boolean {
        try {
            if (_cachedBlurhash == null) {
                return true
            }
            return _cachedBlurhash!!.isDifferent(this.blurhash, this.decodeWidth, this.decodeHeight, this.decodePunch)
        } finally {
            _cachedBlurhash = BlurhashCache(this.blurhash, this.decodeWidth, this.decodeHeight, this.decodePunch)
        }
    }

    private fun emitBlurhashLoadStart() {
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(
                id,
                "blurhashLoadStart",
                null)
    }

    private fun emitBlurhashLoadEnd() {
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(
                id,
                "blurhashLoadEnd",
                null)
    }

    private fun emitBlurhashLoadError(error: String?) {
        val event = Arguments.createMap()
        event.putString("error", error)
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(
                id,
                "blurhashLoadError",
                event)
    }

    private fun log(message: String) {
        if (BuildConfig.DEBUG) {
            Log.d(REACT_CLASS, message)
        }
        RNLog.t("$REACT_CLASS: $message")
    }

    private fun warn(message: String) {
        if (BuildConfig.DEBUG) {
            Log.w(REACT_CLASS, message)
        }
        RNLog.w(context as ReactContext?, "$REACT_CLASS: $message")
    }

    companion object {
        const val REACT_CLASS = "BlurhashImageView"
    }
}