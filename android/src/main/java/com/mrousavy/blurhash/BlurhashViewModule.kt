package com.mrousavy.blurhash

import android.graphics.BitmapFactory
import android.util.Base64
import com.facebook.react.bridge.*
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
                promise.reject("INVALID_COMPONENTS", java.lang.Exception("The componentX and componentY arguments must be greater than 0!"))
                return@thread
            }
            try {
                val formattedUri = imageUri.trim()
                // TODO: Use an Image Loader from React for maximum compatibility - Can't find one though???
                val bitmap = when {
                    formattedUri.startsWith("http", ignoreCase = true) -> {
                        val url = URL(formattedUri)
                        BitmapFactory.decodeStream(url.openConnection().getInputStream())
                    }
                    formattedUri.startsWith("data:image/") -> {
                        val base64 = formattedUri.substring(formattedUri.indexOf(",") + 1)
                        val decodedString: ByteArray = Base64.decode(base64, Base64.DEFAULT)
                        BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
                    }
                    else -> {
                        promise.reject("INVALID_URI", java.lang.Exception("The provided URI is invalid! (does not start with `http` or `data:image/`)"))
                        return@thread
                    }
                }
                if (bitmap == null) {
                    promise.reject("INVALID_URI", java.lang.Exception("Failed to resolve URI $formattedUri!"))
                    return@thread
                }
                val debugDescription =  if (formattedUri.length > 100) { formattedUri.substring(0, 99) }
                                        else { formattedUri }
                RNLog.l("Encoding ${componentsX}x${componentsY} Blurhash from URI $debugDescription...")
                val blurhash = BlurHashEncoder.encode(bitmap, componentsX, componentsY)
                promise.resolve(blurhash)
            } catch (e: Exception) {
                RNLog.e(reactApplicationContext, "Failed to encode Image to Blurhash! ${e.message}")
                promise.reject("INTERNAL", e)
            }
        }
    }

    override fun onHostResume() { }
    override fun onHostPause() { }
    override fun onHostDestroy() {
        BlurHashDecoder.clearCache()
    }
}