package com.mrousavy.blurhash;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.react.uimanager.ReactStylesDiffMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.annotations.ReactPropGroup;
import com.facebook.react.uimanager.annotations.ReactPropertyHolder;
import com.facebook.react.views.image.ReactImageView;

import org.jetbrains.annotations.NotNull;

public class BlurhashViewManager extends SimpleViewManager<ReactImageView> {
    public static final String REACT_CLASS = "BlurhashView";
    private String _blurhash;
    private int _width;
    private int _height;
    private float _punch;

    @ReactProp(name = "blurhash")
    public void setBlurhash(ReactImageView view, String blurhash) {
        Drawable drawable = getBlurhashDrawable(view.getResources(), blurhash, 400, 300, 1.0f);
        view.setBackground(drawable);
    }

    /*
    @ReactPropGroup(names = {"blurhash", "width", "height", "punch"})
    public void setBlurhash(ReactImageView view, String blurhash, int width, int height, float punch) {
        if (view != null && blurhash != null && width > 0 && height > 0 && punch > 0) {
            Drawable drawable = getBlurhashDrawable(view.getResources(), blurhash, width, height, punch);
            view.setBackground(drawable);
        }
    }*/

    @Override
    protected void onAfterUpdateTransaction(@NonNull ReactImageView view) {
        super.onAfterUpdateTransaction(view);
        Log.d(getName(), "On After Update Transaction!!! " + view.toString());
    }

    @Override
    public void updateProperties(@NonNull ReactImageView viewToUpdate, ReactStylesDiffMap props) {
        super.updateProperties(viewToUpdate, props);
        Log.d(getName(), "Update Properties!!! " + props.toString());
    }

    @NotNull
    @Override
    public ReactImageView createViewInstance(ThemedReactContext context) {
        return new ReactImageView(context, Fresco.newDraweeControllerBuilder(), null, null);
    }

    public Drawable getBlurhashDrawable(Resources resources, String blurhash, int width, int height, float punch) {
        Log.d(getName(), "Rendering Blurhash " + blurhash + "...");
        Bitmap bitmap = BlurHashDecoder.Companion.decode(blurhash, width, height, punch);
        return new BitmapDrawable(resources, bitmap);
    }

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }
}