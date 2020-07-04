package com.mrousavy.blurhash

import android.content.Context
import android.util.Log
import com.facebook.drawee.controller.AbstractDraweeControllerBuilder
import com.facebook.react.views.image.GlobalImageLoadListener
import com.facebook.react.views.image.ReactImageView
import com.mrousavy.blurhash.BlurHashDecoder.Companion.decode
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

internal class BlurhashCache(private val _blurhash: String?, private val _decodeWidth: Int, private val _decodeHeight: Int, private val _decodePunch: Float) {
    fun isDifferent(blurhash: String?, decodeWidth: Int, decodeHeight: Int, decodePunch: Float): Boolean {
        return !safeStringEquals(_blurhash, blurhash) || _decodeWidth != decodeWidth || _decodeHeight != decodeHeight || _decodePunch != decodePunch
    }

    private fun safeStringEquals(left: String?, right: String?): Boolean {
        return if (left == null) {
            // left: null and right: null
            right == null
        } else if (right == null) {
            // left: not null and right: null
            false
        } else {
            // left: not null and right: not null
            left == right
        }
    }

}

class BlurhashImageView(context: Context?, draweeControllerBuilder: AbstractDraweeControllerBuilder<*, *, *, *>?, globalImageLoadListener: GlobalImageLoadListener?, callerContext: Any?) : ReactImageView(context, draweeControllerBuilder, globalImageLoadListener, callerContext) {
    var blurhash: String? = null
    var decodeWidth = 32
    var decodeHeight = 32
    var decodePunch = 1.0f
    var decodeAsync = false
    private var _cachedBlurhash: BlurhashCache? = null
    private var _mainThreadId = Thread.currentThread().id

    fun getThreadDescriptor(): String {
        return if (Thread.currentThread().id == this._mainThreadId) "main"
        else "separate"
    }

    private fun renderBlurhash(decodeAsync: Boolean) {
        if (decodeAsync) {
            GlobalScope.launch {
                Log.d(REACT_CLASS, "Decoding ${decodeWidth}x${decodeHeight} blurhash ($blurhash) on ${getThreadDescriptor()} Thread!")
                val bitmap = decode(blurhash, decodeWidth, decodeHeight, decodePunch)
                setImageBitmap(bitmap) // TODO: why is setImageBitmap() deprecated? https://developer.android.com/reference/android/widget/ImageView#setImageBitmap(android.graphics.Bitmap)
                _cachedBlurhash = BlurhashCache(blurhash, decodeWidth, decodeHeight, decodePunch)
            }
        } else {
            Log.d(REACT_CLASS, "Decoding ${decodeWidth}x${decodeHeight} blurhash ($blurhash) on ${getThreadDescriptor()} Thread!")
            val bitmap = decode(blurhash, decodeWidth, decodeHeight, decodePunch)
            setImageBitmap(bitmap) // TODO: why is setImageBitmap() deprecated? https://developer.android.com/reference/android/widget/ImageView#setImageBitmap(android.graphics.Bitmap)
            _cachedBlurhash = BlurhashCache(blurhash, decodeWidth, decodeHeight, decodePunch)
        }
    }

    fun updateBlurhash() {
        val shouldUpdate = _cachedBlurhash == null || _cachedBlurhash!!.isDifferent(blurhash, decodeWidth, decodeHeight, decodePunch)
        if (shouldUpdate) {
            if (decodeWidth > 0 && decodeHeight > 0 && decodePunch > 0) {
                renderBlurhash(this.decodeAsync)
            } else {
                Log.w(REACT_CLASS, "Width, Height and Punch properties of Blurhash View must be greater than 0!")
            }
        } else {
            Log.d(REACT_CLASS, "No props changed -> No update neccessary.")
        }
    }

    companion object {
        const val REACT_CLASS = "BlurhashImageView"
    }
}