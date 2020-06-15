package com.mrousavy.blurhash;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeControllerBuilder;
import com.facebook.react.uimanager.ReactStylesDiffMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.annotations.ReactPropGroup;
import com.facebook.react.uimanager.annotations.ReactPropertyHolder;
import com.facebook.react.views.image.GlobalImageLoadListener;
import com.facebook.react.views.image.ReactImageView;

import org.jetbrains.annotations.NotNull;



public class BlurhashViewManager extends SimpleViewManager<BlurhashImageView> {
    public static final String REACT_CLASS = "BlurhashView";
    private String _blurhash;
    private int _width;
    private int _height;
    private float _punch = 1.0f;

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

    @Override
    protected void onAfterUpdateTransaction(@NonNull BlurhashImageView view) {
        super.onAfterUpdateTransaction(view);
        Log.d(getName(), "On After Update Transaction!!! " + view.toString());
    }

    @Override
    public void updateProperties(@NonNull BlurhashImageView viewToUpdate, ReactStylesDiffMap props) {
        super.updateProperties(viewToUpdate, props);
        Log.d(getName(), "Update Properties!!! " + props.toString());
    }

    @NotNull
    @Override
    public BlurhashImageView createViewInstance(@NotNull ThemedReactContext context) {
        Log.d(getName(), "Creating View Instance!");
        return new BlurhashImageView(context, Fresco.newDraweeControllerBuilder(), null, null);
    }

    public Drawable getBlurhashDrawable(Resources resources, String blurhash, int width, int height, float punch) {
        if (blurhash != null && width > 0 && height > 0 && punch > 0) {
            Log.d(getName(), "Rendering Blurhash " + blurhash + "...");
            Bitmap bitmap = BlurHashDecoder.Companion.decode(blurhash, width, height, punch);
            return new BitmapDrawable(resources, bitmap);
        } else {
            return null;
        }
    }

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }
}