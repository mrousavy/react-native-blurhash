package com.mrousavy.blurhash;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.drawee.controller.AbstractDraweeControllerBuilder;
import com.facebook.react.views.image.GlobalImageLoadListener;
import com.facebook.react.views.image.ImageResizeMethod;
import com.facebook.react.views.image.ReactImageView;

class BlurhashState {
    private String _blurhash;
    private int _width;
    private int _height;
    private float _punch = 1.0f;
    private Bitmap _bitmap;

    public BlurhashState(String blurhash, int width, int height, float punch, Bitmap bitmap) {
        this._blurhash = blurhash;
        this._width = width;
        this._height = height;
        this._punch = punch;
        this._bitmap = bitmap;
    }

    public Bitmap getBitmap() {
        return _bitmap;
    }

    public boolean isDifferent(String blurhash, int width, int height, float punch) {
        return !safeStringEquals(this._blurhash, blurhash) || this._width != width || this._height != height || this._punch != punch;
    }

    private boolean safeStringEquals(String left, String right) {
        if (left == null) {
            return right == null;
        } else if (right == null) {
            return left == null;
        } else {
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
    private BlurhashState _cachedBlurhash;
    private Paint _paint;

    public BlurhashImageView(Context context, AbstractDraweeControllerBuilder draweeControllerBuilder, @Nullable GlobalImageLoadListener globalImageLoadListener, @Nullable Object callerContext) {
        super(context, draweeControllerBuilder, globalImageLoadListener, callerContext);
        this.setResizeMethod(ImageResizeMethod.SCALE);
        this._paint = new Paint();
        this._paint.setAntiAlias(true);
        this._paint.setFilterBitmap(true);
        this._paint.setDither(true);
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

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        Log.d(REACT_CLASS, "Size changed!! " + w + " : " + h);
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        Log.d(REACT_CLASS, "Drawing canvas!!");
        Bitmap bitmap = Bitmap.createScaledBitmap(_cachedBlurhash.getBitmap(), canvas.getWidth(), canvas.getHeight(), true);
        canvas.drawBitmap(bitmap, 0, 0, this._paint);
    }

    private void updateBlurhashBitmap() {
        Log.d(REACT_CLASS, "Should I update blurhash bitmap?");
        if (_cachedBlurhash == null || _cachedBlurhash.isDifferent(_blurhash, _width, _height, _punch)) {
            Log.d(REACT_CLASS, "Yes, updating Blurhash bitmap...");
            if (this._width > 0 && this._height > 0 && this._punch > 0) {
                Bitmap bitmap = BlurHashDecoder.Companion.decode(this._blurhash, this._width, this._height, this._punch);
                this._cachedBlurhash = new BlurhashState(_blurhash, _width, _height, _punch, bitmap);
            } else {
                Log.w(REACT_CLASS, "Width, Height and Punch properties of Blurhash View must be greater than 0!");
            }
        } else {
            Log.d(REACT_CLASS, "No, using cached Blurhash bitmap...");
        }
    }
}