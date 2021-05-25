#import "BlurhashBridge.h"
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_REMAP_MODULE(BlurhashView, BlurhashViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(blurhash, NSString);
RCT_EXPORT_VIEW_PROPERTY(decodeWidth, NSNumber);
RCT_EXPORT_VIEW_PROPERTY(decodeHeight, NSNumber);
RCT_EXPORT_VIEW_PROPERTY(decodePunch, NSNumber);
RCT_EXPORT_VIEW_PROPERTY(decodeAsync, BOOL);

RCT_EXPORT_VIEW_PROPERTY(resizeMode, NSString);

RCT_EXPORT_VIEW_PROPERTY(onLoadStart, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLoadEnd, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onLoadError, RCTDirectEventBlock);

RCT_EXTERN_METHOD(createBlurhashFromImage:(nonnull NSString *)imageUri componentsX:(nonnull NSNumber *)componentsX componentsY:(nonnull NSNumber *)componentsY resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject);

@end
