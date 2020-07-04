package com.mrousavy.blurhash

import android.graphics.BitmapFactory
import com.facebook.react.bridge.*
import java.lang.Exception
import java.net.URL
import kotlin.concurrent.thread

class BlurhashViewModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), LifecycleEventListener {
    companion object {
        const val REACT_CLASS = "BlurhashView"
    }

    override fun getName(): String {
        return REACT_CLASS
    }

    @ReactMethod
    fun createBlurhashFromImage(imageUri: String, componentsX: Int, componentsY: Int, promise: Promise) {
        thread(true) {
            RNLog.l("Thread started")
            if (componentsX < 1 || componentsY < 1) {
                promise.reject("COMPONENTS_INVALID", "The componentX and componentY arguments must be greater than 0!")
                return@thread
            }
            try {
                val url = URL(imageUri)
                val bitmap = BitmapFactory.decodeStream(url.openConnection().getInputStream())
                RNLog.l("Encoding ${componentsX}x${componentsY} Blurhash from URI $imageUri...")
                val blurhash = BlurHashEncoder.encode(bitmap, componentsX, componentsY)
                promise.resolve(blurhash)
            } catch (e: Exception) {
                promise.reject("INTERNAL", "An unexpected error occured!", e)
            }
        }
    }

    override fun onHostResume() { }
    override fun onHostPause() { }
    override fun onHostDestroy() { }
}