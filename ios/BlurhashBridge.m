#import "BlurhashBridge.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_REMAP_MODULE(Blurhash, Blurhash, RCTViewManager)

RCT_CUSTOM_VIEW_PROPERTY(blurhash, NSString, Blurhash)
{
	[view setBlurhash:blurhash];
}

RCT_CUSTOM_VIEW_PROPERTY(width, int, Blurhash)
{
	[view setWidth:width];
}

RCT_CUSTOM_VIEW_PROPERTY(height, int, Blurhash)
{
	[view setHeight:height];
}

@end
