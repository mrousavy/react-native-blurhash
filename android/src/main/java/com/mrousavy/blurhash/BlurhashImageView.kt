package com.mrousavy.blurhash

import android.content.Context
import android.graphics.Bitmap
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

const val USE_COSINES_CACHE = true

class BlurhashImageView(context: Context): androidx.appcompat.widget.AppCompatImageView(context) {
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

    private fun renderBlurhash() {
        try {
            emitBlurhashLoadStart()
            if (blurhash == null) {
                throw Exception("The provided Blurhash string must not be null!")
            }
            if (decodeWidth <= 0) {
                throw Exception("decodeWidth must be greater than 0! Actual: $decodeWidth")
            }
            if (decodeHeight <= 0) {
                throw Exception("decodeHeight must be greater than 0! Actual: $decodeWidth")
            }
            if (decodePunch <= 0) {
                throw Exception("decodePunch must be greater than 0! Actual: $decodeWidth")
            }
            _bitmap = BlurHashDecoder.decode(blurhash, decodeWidth, decodeHeight, decodePunch, USE_COSINES_CACHE)
            if (_bitmap == null) {
                throw Exception("The provided Blurhash string was invalid.")
            }
            setImageBitmap(_bitmap)
            emitBlurhashLoadEnd()
        } catch (e: Exception) {
            setImageBitmap(null)
            emitBlurhashLoadError(e.message)
        }
    }

    fun updateBlurhash() {
        val shouldReRender = this.shouldReRender()
        if (shouldReRender) {
            if (decodeAsync) {
                GlobalScope.launch {
                    renderBlurhash()
                }
            } else {
                renderBlurhash()
            }
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
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, "blurhashLoadStart", null)
    }

    private fun emitBlurhashLoadEnd() {
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, "blurhashLoadEnd", null)
    }

    private fun emitBlurhashLoadError(message: String?) {
        val event = Arguments.createMap()
        event.putString("message", message)
        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, "blurhashLoadError", event)
    }

    companion object {
        const val REACT_CLASS = "BlurhashImageView"
    }
}
