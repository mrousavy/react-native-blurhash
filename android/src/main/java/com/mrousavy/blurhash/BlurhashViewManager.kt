package com.mrousavy.blurhash

import android.widget.ImageView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.ViewProps
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.Event
import com.facebook.react.viewmanagers.BlurhashViewManagerDelegate
import com.facebook.react.viewmanagers.BlurhashViewManagerInterface

internal class LoadStartEvent(
    surfaceId: Int,
    viewTag: Int,
) : Event<LoadStartEvent>(surfaceId, viewTag) {
  override fun getEventName() = EVENT_NAME

  override fun getEventData(): WritableMap = Arguments.createMap()

  companion object {
    const val EVENT_NAME = "topLoadStart"
  }
}

internal class LoadEndEvent(
    surfaceId: Int,
    viewTag: Int,
) : Event<LoadStartEvent>(surfaceId, viewTag) {
  override fun getEventName() = EVENT_NAME

  override fun getEventData(): WritableMap = Arguments.createMap()

  companion object {
    const val EVENT_NAME = "topLoadEnd"
  }
}

internal class LoadErrorEvent(
    surfaceId: Int,
    viewTag: Int,
    var message: String?,
) : Event<LoadStartEvent>(surfaceId, viewTag) {
  override fun getEventName() = EVENT_NAME

  override fun getEventData(): WritableMap =
      Arguments.createMap().apply { putString("message", message) }

  companion object {
    const val EVENT_NAME = "topLoadError"
  }
}

val DEFAULT_RESIZE_MODE = ImageView.ScaleType.CENTER_CROP

class BlurhashViewManager :
    SimpleViewManager<BlurhashImageView>(), BlurhashViewManagerInterface<BlurhashImageView> {
  private val mDelegate: ViewManagerDelegate<BlurhashImageView>

  init {
    mDelegate = BlurhashViewManagerDelegate(this)
  }

  @ReactProp(name = "blurhash")
  override fun setBlurhash(view: BlurhashImageView, blurhash: String?) {
    view.blurhash = blurhash
  }

  @ReactProp(name = "decodeWidth", defaultInt = 32)
  override fun setDecodeWidth(view: BlurhashImageView, decodeWidth: Int) {
    view.decodeWidth = decodeWidth
  }

  @ReactProp(name = "decodeHeight", defaultInt = 32)
  override fun setDecodeHeight(view: BlurhashImageView, decodeHeight: Int) {
    view.decodeHeight = decodeHeight
  }

  @ReactProp(name = "decodePunch", defaultDouble = 1.0)
  override fun setDecodePunch(view: BlurhashImageView, decodePunch: Double) {
    view.decodePunch = decodePunch.toFloat()
  }

  @ReactProp(name = "decodeAsync", defaultBoolean = false)
  override fun setDecodeAsync(view: BlurhashImageView, decodeAsync: Boolean) {
    view.decodeAsync = decodeAsync
  }

  @ReactProp(name = ViewProps.RESIZE_MODE)
  override fun setResizeMode(view: BlurhashImageView, resizeMode: String?) {
    view.scaleType = parseResizeMode(resizeMode ?: "cover")
    view.redraw()
  }

  override fun onAfterUpdateTransaction(view: BlurhashImageView) {
    super.onAfterUpdateTransaction(view)
    view.updateBlurhash()
  }

  public override fun createViewInstance(context: ThemedReactContext): BlurhashImageView {
    val image = BlurhashImageView(context)
    image.clipToOutline = true
    image.scaleType = DEFAULT_RESIZE_MODE
    return image
  }

  override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any>? {
    return MapBuilder.builder<String, Any>()
        .put(LoadErrorEvent.EVENT_NAME, MapBuilder.of("registrationName", "onLoadError"))
        .put(LoadStartEvent.EVENT_NAME, MapBuilder.of("registrationName", "onLoadStart"))
        .put(LoadEndEvent.EVENT_NAME, MapBuilder.of("registrationName", "onLoadEnd"))
        .build()
  }

  override fun getName() = REACT_CLASS

  override fun getDelegate() = mDelegate

  override fun addEventEmitters(reactContext: ThemedReactContext, view: BlurhashImageView) {
    super.addEventEmitters(reactContext, view)

    val dispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
    val surfaceId = UIManagerHelper.getSurfaceId(reactContext)

    if (dispatcher != null) {
      view.onLoadStart = { dispatcher.dispatchEvent(LoadStartEvent(surfaceId, view.id)) }
      view.onLoadEnd = { dispatcher.dispatchEvent(LoadEndEvent(surfaceId, view.id)) }
      view.onLoadError = { message ->
        dispatcher.dispatchEvent(LoadErrorEvent(surfaceId, view.id, message))
      }
    }
  }

  companion object {
    const val REACT_CLASS = "BlurhashView"

    fun parseResizeMode(resizeMode: String): ImageView.ScaleType {
      return when (resizeMode) {
        "contain" -> ImageView.ScaleType.FIT_CENTER
        "cover" -> ImageView.ScaleType.CENTER_CROP
        "stretch" -> ImageView.ScaleType.FIT_XY
        "center" -> ImageView.ScaleType.CENTER_INSIDE
        else -> DEFAULT_RESIZE_MODE
      }
    }
  }
}
