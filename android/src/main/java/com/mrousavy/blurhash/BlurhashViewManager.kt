package com.mrousavy.blurhash

import android.os.Build
import android.widget.ImageView
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.yoga.YogaConstants


class BlurhashViewManager : SimpleViewManager<BlurhashImageView>() {
    @ReactProp(name = "blurhash")
    fun setBlurhash(view: BlurhashImageView, blurhash: String?) {
        view.blurhash = blurhash
    }

    @ReactProp(name = "decodeWidth", defaultInt = 32)
    fun setDecodeWidth(view: BlurhashImageView, decodeWidth: Int) {
        view.decodeWidth = decodeWidth
    }

    @ReactProp(name = "decodeHeight", defaultInt = 32)
    fun setDecodeHeight(view: BlurhashImageView, decodeHeight: Int) {
        view.decodeHeight = decodeHeight
    }

    @ReactProp(name = "decodePunch", defaultFloat = 1.0f)
    fun setDecodePunch(view: BlurhashImageView, decodePunch: Float) {
        view.decodePunch = decodePunch
    }

    @ReactProp(name = "decodeAsync", defaultFloat = 1.0f)
    fun setDecodeAsync(view: BlurhashImageView, decodeAsync: Boolean) {
        view.decodeAsync = decodeAsync
    }

    @ReactProp(name = "resizeMode")
    fun setResizeMode(view: BlurhashImageView, resizeMode: String) {
        view.setScaleType(parseResizeMode(resizeMode))
    }

    override fun onAfterUpdateTransaction(view: BlurhashImageView) {
        super.onAfterUpdateTransaction(view)
        view.updateBlurhash()
    }

    public override fun createViewInstance(context: ThemedReactContext): BlurhashImageView {
        val image = BlurhashImageView(context, Fresco.newDraweeControllerBuilder(), null, null)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            image.clipToOutline = true
        }
        image.setScaleType(ImageView.ScaleType.CENTER_CROP)
        return image
    }

    override fun getName(): String {
        return REACT_CLASS
    }

    companion object {
        const val REACT_CLASS = "BlurhashView"

        fun parseResizeMode(resizeMode: String): ImageView.ScaleType {
            return when(resizeMode) {
                "contain" -> ImageView.ScaleType.FIT_CENTER
                "cover" -> ImageView.ScaleType.CENTER_CROP
                "stretch" -> ImageView.ScaleType.FIT_XY
                "center" -> ImageView.ScaleType.CENTER_INSIDE
                else -> ImageView.ScaleType.CENTER_CROP
            }
        }
    }
}
