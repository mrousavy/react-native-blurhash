package com.mrousavy.blurhash;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;

import androidx.annotation.Nullable;

import com.facebook.drawee.controller.AbstractDraweeControllerBuilder;
import com.facebook.react.views.image.GlobalImageLoadListener;
import com.facebook.react.views.image.ReactImageView;

class BlurhashCache {
    private String _blurhash;
    private int _decodeWidth;
    private int _decodeHeight;
    private float _decodePunch;

    public BlurhashCache(String blurhash, int decodeWidth, int decodeHeight, float decodePunch) {
        this._blurhash = blurhash;
        this._decodeWidth = decodeWidth;
        this._decodeHeight = decodeHeight;
        this._decodePunch = decodePunch;
    }

    public boolean isDifferent(String blurhash, int decodeWidth, int decodeHeight, float decodePunch) {
        Log.d("Comparing: " + _blurhash + ":" + blurhash + ", " + _decodeWidth + ":"+ decodeWidth + ", " + _decodeHeight + ":" + decodeHeight, ", " + _decodePunch + ":" + decodePunch);
        return !safeStringEquals(this._blurhash, blurhash) || this._decodeWidth != decodeWidth || this._decodeHeight != decodeHeight || this._decodePunch != decodePunch;
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
    private int _decodeWidth;
    private int _decodeHeight;
    private float _decodePunch = 1.0f;
    private BlurhashCache _cachedBlurhash;

    public BlurhashImageView(Context context, AbstractDraweeControllerBuilder draweeControllerBuilder, @Nullable GlobalImageLoadListener globalImageLoadListener, @Nullable Object callerContext) {
        super(context, draweeControllerBuilder, globalImageLoadListener, callerContext);
    }

    public void setBlurhash(String _blurhash) {
        this._blurhash = _blurhash;
        this.updateBlurhashBitmap();
    }

    public void setDecodeWidth(int decodeWidth) {
        this._decodeWidth = decodeWidth;
        this.updateBlurhashBitmap();
    }

    public void setDecodeHeight(int decodeHeight) {
        this._decodeHeight = decodeHeight;
        this.updateBlurhashBitmap();
    }

    public void setDecodePunch(float decodePunch) {
        this._decodePunch = decodePunch;
        this.updateBlurhashBitmap();
    }

    private void updateBlurhashBitmap() {
        boolean shouldUpdate = _cachedBlurhash == null || _cachedBlurhash.isDifferent(_blurhash, _decodeWidth, _decodeHeight, _decodePunch);
        if (shouldUpdate) {
            if (this._decodeWidth > 0 && this._decodeHeight > 0 && this._decodePunch > 0) {
                Log.d(REACT_CLASS, "Decoding Bitmap...");
                Bitmap bitmap = BlurHashDecoder.Companion.decode(this._blurhash, this._decodeWidth, this._decodeHeight, this._decodePunch);
                Drawable drawable = new BitmapDrawable(getResources(), bitmap);
                this.setBackground(drawable);
                this._cachedBlurhash = new BlurhashCache(this._blurhash, this._decodeWidth, this._decodeHeight, this._decodePunch);
            } else {
                Log.w(REACT_CLASS, "Width, Height and Punch properties of Blurhash View must be greater than 0!");
            }
        } else {
            Log.d(REACT_CLASS, "No props changed -> No update neccessary.");
        }
    }
}