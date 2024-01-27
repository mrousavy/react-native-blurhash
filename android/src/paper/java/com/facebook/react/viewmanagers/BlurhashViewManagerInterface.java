/**
* This code was generated by [react-native-codegen](https://www.npmjs.com/package/react-native-codegen).
*
* Do not edit this file as changes may cause incorrect behavior and will be lost
* once the code is regenerated.
*
* @generated by codegen project: GeneratePropsJavaInterface.js
*/

package com.facebook.react.viewmanagers;

import android.view.View;
import androidx.annotation.Nullable;

public interface BlurhashViewManagerInterface<T extends View> {
  void setBlurhash(T view, @Nullable String value);
  void setDecodeWidth(T view, int value);
  void setDecodeHeight(T view, int value);
  void setDecodePunch(T view, double value);
  void setDecodeAsync(T view, boolean value);
  void setResizeMode(T view, @Nullable String value);
}
