package com.mrousavy.blurhash

import android.graphics.Bitmap
import android.net.Uri
import com.facebook.common.executors.CallerThreadExecutor
import com.facebook.common.references.CloseableReference
import com.facebook.datasource.DataSource
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.imagepipeline.datasource.BaseBitmapDataSubscriber
import com.facebook.imagepipeline.image.CloseableImage
import com.facebook.imagepipeline.request.ImageRequestBuilder
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import kotlin.concurrent.thread

@ReactModule(name = NativeBlurhashModuleSpec.NAME)
class BlurhashModule(reactContext: ReactApplicationContext) :
    NativeBlurhashModuleSpec(reactContext), LifecycleEventListener {
  @ReactMethod
  override fun createBlurhashFromImage(
      imageUri: String,
      componentsX: Int,
      componentsY: Int,
      promise: Promise
  ) {
    thread(true) {
      if (componentsX < 1 || componentsY < 1) {
        promise.reject(
            "INVALID_COMPONENTS",
            Exception("The componentX and componentY arguments must be greater than 0!"))
        return@thread
      }
      try {
        val formattedUri = imageUri.trim()

        val imageRequest = ImageRequestBuilder.newBuilderWithSource(Uri.parse(formattedUri)).build()
        val imagePipeline = Fresco.getImagePipeline()
        val dataSource = imagePipeline.fetchDecodedImage(imageRequest, reactApplicationContext)
        dataSource.subscribe(
            object : BaseBitmapDataSubscriber() {
              override fun onNewResultImpl(bitmap: Bitmap?) {
                try {
                  if (dataSource.isFinished && bitmap != null) {
                    val blurhash = BlurHashEncoder.encode(bitmap, componentsX, componentsY)
                    promise.resolve(blurhash)
                  } else {
                    if (dataSource.failureCause != null) {
                      promise.reject("LOAD_ERROR", dataSource.failureCause)
                    } else {
                      promise.reject("LOAD_ERROR", Exception("Failed to load URI!"))
                    }
                  }
                } finally {
                  dataSource.close()
                }
              }

              override fun onFailureImpl(
                  dataSource: DataSource<CloseableReference<CloseableImage>>
              ) {
                try {
                  if (dataSource.failureCause != null) {
                    promise.reject("LOAD_ERROR", dataSource.failureCause)
                  } else {
                    promise.reject("LOAD_ERROR", Exception("Failed to load URI!"))
                  }
                } finally {
                  dataSource.close()
                }
              }
            },
            CallerThreadExecutor.getInstance())
      } catch (e: Exception) {
        promise.reject("INTERNAL", e)
      }
    }
  }

  @ReactMethod
  override fun clearCosineCache() {
    BlurHashDecoder.clearCache()
  }

  override fun onHostResume() {}

  override fun onHostPause() {}

  override fun onHostDestroy() {
    BlurHashDecoder.clearCache()
  }
}
