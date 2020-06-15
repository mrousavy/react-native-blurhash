package com.mrousavy.blurhash

import android.content.Context
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Log
import com.facebook.drawee.controller.AbstractDraweeControllerBuilder
import com.facebook.react.views.image.GlobalImageLoadListener
import com.facebook.react.views.image.ReactImageView
import com.mrousavy.blurhash.BlurHashDecoder.Companion.decode

internal class BlurhashCache(private val _blurhash: String?, private val _decodeWidth: Int, private val _decodeHeight: Int, private val _decodePunch: Float) {
    fun isDifferent(blurhash: String?, decodeWidth: Int, decodeHeight: Int, decodePunch: Float): Boolean {
        Log.d("Comparing: $_blurhash:$blurhash, $_decodeWidth:$decodeWidth, $_decodeHeight:$decodeHeight", ", $_decodePunch:$decodePunch")
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
    private var _blurhash: String? = null
    private var _decodeWidth = 0
    private var _decodeHeight = 0
    private var _decodePunch = 1.0f
    private var _cachedBlurhash: BlurhashCache? = null
    fun setBlurhash(_blurhash: String?) {
        this._blurhash = _blurhash
        updateBlurhashBitmap()
    }

    fun setDecodeWidth(decodeWidth: Int) {
        _decodeWidth = decodeWidth
        updateBlurhashBitmap()
    }

    fun setDecodeHeight(decodeHeight: Int) {
        _decodeHeight = decodeHeight
        updateBlurhashBitmap()
    }

    fun setDecodePunch(decodePunch: Float) {
        _decodePunch = decodePunch
        updateBlurhashBitmap()
    }

    private fun updateBlurhashBitmap() {
        val shouldUpdate = _cachedBlurhash == null || _cachedBlurhash!!.isDifferent(_blurhash, _decodeWidth, _decodeHeight, _decodePunch)
        if (shouldUpdate) {
            if (_decodeWidth > 0 && _decodeHeight > 0 && _decodePunch > 0) {
                Log.d(REACT_CLASS, "Decoding Bitmap...")
                val bitmap = decode(_blurhash, _decodeWidth, _decodeHeight, _decodePunch)
                val drawable: Drawable = BitmapDrawable(resources, bitmap)
                this.background = drawable
                _cachedBlurhash = BlurhashCache(_blurhash, _decodeWidth, _decodeHeight, _decodePunch)
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