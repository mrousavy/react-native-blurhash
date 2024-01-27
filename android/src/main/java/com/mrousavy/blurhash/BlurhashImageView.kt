package com.mrousavy.blurhash

import android.content.Context
import android.graphics.Bitmap
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
    var onLoadStart: (() -> Unit)? = null
    var onLoadEnd: (() -> Unit)? = null
    var onLoadError: ((String?) -> Unit)? = null

    private var _cachedBlurhash: BlurhashCache? = null
    private var _bitmap: Bitmap? = null

    private fun renderBlurhash() {
        try {
            onLoadStart?.invoke()
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
            onLoadEnd?.invoke()
        } catch (e: Exception) {
            setImageBitmap(null)
            onLoadError?.invoke(e.message)
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

    companion object {
        const val REACT_CLASS = "BlurhashImageView"
    }
}
