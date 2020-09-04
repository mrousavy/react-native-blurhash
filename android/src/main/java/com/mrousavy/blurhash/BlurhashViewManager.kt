package com.mrousavy.blurhash

import android.os.Build
import android.widget.ImageView
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewProps
import com.facebook.react.uimanager.annotations.ReactProp


val DEFAULT_RESIZE_MODE = ImageView.ScaleType.CENTER_CROP

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

    @ReactProp(name = "decodeAsync", defaultBoolean = false)
    fun setDecodeAsync(view: BlurhashImageView, decodeAsync: Boolean) {
        view.decodeAsync = decodeAsync
    }

    @ReactProp(name = ViewProps.RESIZE_MODE)
    fun setResizeMode(view: BlurhashImageView, resizeMode: String) {
        view.scaleType = parseResizeMode(resizeMode)
        view.redraw()
    }

    override fun onAfterUpdateTransaction(view: BlurhashImageView) {
        super.onAfterUpdateTransaction(view)
        view.updateBlurhash()
    }

    public override fun createViewInstance(context: ThemedReactContext): BlurhashImageView {
        val image = BlurhashImageView(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            image.clipToOutline = true
        }
        image.scaleType = DEFAULT_RESIZE_MODE
        return image
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any>? {
        return MapBuilder.builder<String, Any>()
                .put("blurhashLoadError", MapBuilder.of("registrationName", "onLoadError"))
                .put("blurhashLoadStart", MapBuilder.of("registrationName", "onLoadStart"))
                .put("blurhashLoadEnd", MapBuilder.of("registrationName", "onLoadEnd"))
                .build()
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
                else -> DEFAULT_RESIZE_MODE
            }
        }
    }
}
