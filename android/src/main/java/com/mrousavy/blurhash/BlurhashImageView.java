package com.mrousavy.blurhash;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;

import androidx.annotation.Nullable;

import com.facebook.drawee.controller.AbstractDraweeControllerBuilder;
import com.facebook.react.views.image.GlobalImageLoadListener;
import com.facebook.react.views.image.ImageResizeMethod;
import com.facebook.react.views.image.ReactImageView;

class BlurhashCache {
    private String _blurhash;
    private int _width;
    private int _height;
    private float _punch = 1.0f;

    public BlurhashCache(String blurhash, int width, int height, float punch) {
        this._blurhash = blurhash;
        this._width = width;
        this._height = height;
        this._punch = punch;
    }

    public boolean isDifferent(String blurhash, int width, int height, float punch) {
        Log.d("Comparing: " + _blurhash + ":" + blurhash + ", " + _width + ":"+ width + ", " + _height + ":" + height, ", " + _punch + ":" + punch);
        return !safeStringEquals(this._blurhash, blurhash) || this._width != width || this._height != height || this._punch != punch;
    }

    private boolean safeStringEquals(String left, String right) {
        if (left == null) {
            // left: null and right: null
            return right == null;
        } else if (right == null) {
            // left: not null and right: null
            return false;
        } else {
            // left: not null and right: not null
            return left.equals(right);
        }
    }
}

public class BlurhashImageView extends ReactImageView {
    public static final String REACT_CLASS = "BlurhashImageView";
    private String _blurhash;
    private int _width;
    private int _height;
    private float _punch = 1.0f;
    private BlurhashCache _cachedBlurhash;

    public BlurhashImageView(Context context, AbstractDraweeControllerBuilder draweeControllerBuilder, @Nullable GlobalImageLoadListener globalImageLoadListener, @Nullable Object callerContext) {
        super(context, draweeControllerBuilder, globalImageLoadListener, callerContext);
    }

    public void set_blurhash(String _blurhash) {
        this._blurhash = _blurhash;
        this.updateBlurhashBitmap();
    }

    public void set_width(int _width) {
        this._width = _width;
        this.updateBlurhashBitmap();
    }

    public void set_height(int _height) {
        this._height = _height;
        this.updateBlurhashBitmap();
    }

    public void set_punch(float _punch) {
        this._punch = _punch;
        this.updateBlurhashBitmap();
    }

    private void updateBlurhashBitmap() {
        boolean shouldUpdate = _cachedBlurhash == null || _cachedBlurhash.isDifferent(_blurhash, _width, _height, _punch);
        if (shouldUpdate) {
            if (this._width > 0 && this._height > 0 && this._punch > 0) {
                Log.d(REACT_CLASS, "Decoding Bitmap...");
                Bitmap bitmap = BlurHashDecoder.Companion.decode(this._blurhash, this._width, this._height, this._punch);
                Drawable drawable = new BitmapDrawable(getResources(), bitmap);
                this.setBackground(drawable);
                this._cachedBlurhash = new BlurhashCache(this._blurhash, this._width, this._height, this._punch);
            } else {
                Log.w(REACT_CLASS, "Width, Height and Punch properties of Blurhash View must be greater than 0!");
            }
        } else {
            Log.d(REACT_CLASS, "No props changed -> No update neccessary.");
        }
    }
}