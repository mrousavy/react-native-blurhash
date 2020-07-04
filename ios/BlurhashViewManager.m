#import "BlurhashBridge.h"
#import "React/RCTViewManager.h"
#import "React/RCTLog.h"

@interface RCT_EXTERN_MODULE(BlurhashViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(blurhash, NSString)
RCT_EXPORT_VIEW_PROPERTY(decodeWidth, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(decodeHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(decodePunch, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(decodeAsync, BOOL)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, NSString)

@end
