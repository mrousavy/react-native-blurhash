package com.mrousavy.blurhash

import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

class BlurhashViewManager : SimpleViewManager<BlurhashImageView>() {
    @ReactProp(name = "blurhash")
    fun setBlurhash(view: BlurhashImageView, blurhash: String?) {
        view.setBlurhash(blurhash)
    }

    @ReactProp(name = "decodeWidth")
    fun setDecodeWidth(view: BlurhashImageView, decodeWidth: Int) {
        view.setDecodeWidth(decodeWidth)
    }

    @ReactProp(name = "decodeHeight")
    fun setDecodeHeight(view: BlurhashImageView, decodeHeight: Int) {
        view.setDecodeHeight(decodeHeight)
    }

    @ReactProp(name = "decodePunch", defaultFloat = 1.0f)
    fun setDecodePunch(view: BlurhashImageView, decodePunch: Float) {
        view.setDecodePunch(decodePunch)
    }

    public override fun createViewInstance(context: ThemedReactContext): BlurhashImageView {
        return BlurhashImageView(context, Fresco.newDraweeControllerBuilder(), null, null)
    }

    override fun getName(): String {
        return REACT_CLASS
    }

    companion object {
        const val REACT_CLASS = "BlurhashView"
    }
}