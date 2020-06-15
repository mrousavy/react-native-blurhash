package com.mrousavy.blurhash;

import androidx.annotation.NonNull;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import org.jetbrains.annotations.NotNull;

public class BlurhashViewManager extends SimpleViewManager<BlurhashImageView> {
    public static final String REACT_CLASS = "BlurhashView";
    @ReactProp(name = "blurhash")
    public void setBlurhash(BlurhashImageView view, String blurhash) {
        view.setBlurhash(blurhash);
    }

    @ReactProp(name = "decodeWidth")
    public void setDecodeWidth(BlurhashImageView view, int decodeWidth) {
        view.setDecodeWidth(decodeWidth);
    }

    @ReactProp(name = "decodeHeight")
    public void setDecodeHeight(BlurhashImageView view, int decodeHeight) {
        view.setDecodeHeight(decodeHeight);
    }

    @ReactProp(name = "decodePunch", defaultFloat = 1.0f)
    public void setDecodePunch(BlurhashImageView view, float decodePunch) {
        view.setDecodePunch(decodePunch);
    }

    @NotNull
    @Override
    public BlurhashImageView createViewInstance(@NotNull ThemedReactContext context) {
        return new BlurhashImageView(context, Fresco.newDraweeControllerBuilder(), null, null);
    }

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }
}