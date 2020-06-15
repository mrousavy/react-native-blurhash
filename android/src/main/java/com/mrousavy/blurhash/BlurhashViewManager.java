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
        view.set_blurhash(blurhash);
    }

    @ReactProp(name = "width")
    public void setWidth(BlurhashImageView view, int width) {
        view.set_width(width);
    }

    @ReactProp(name = "height")
    public void setHeight(BlurhashImageView view, int height) {
        view.set_height(height);
    }

    @ReactProp(name = "punch", defaultFloat = 1.0f)
    public void setPunch(BlurhashImageView view, float punch) {
        view.set_punch(punch);
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