#import "BlurhashBridge.h"
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(BlurhashViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(blurhash, NSString)
RCT_EXPORT_VIEW_PROPERTY(width, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(height, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(punch, NSNumber)

@end
