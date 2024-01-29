#import "BlurhashModule.h"

#import <React/RCTUtils.h>
#import <UIKit/UIKit.h>
#ifdef RCT_NEW_ARCH_ENABLED
#import <blurhash_codegen/blurhash_codegen.h>
#endif

#import "react_native_blurhash-Swift.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;

@interface BlurhashModule () <NativeBlurhashModuleSpec>
@end
#endif

@interface BlurhashModule ()

@property (nonatomic, strong) BlurhashModuleImpl *impl;

@end

@implementation BlurhashModule

RCT_EXPORT_MODULE()

@synthesize moduleRegistry = _moduleRegistry;

RCT_EXPORT_METHOD(createBlurhashFromImage
                  : (NSString *)imageUri componentsX
                  : (double)componentsX componentsY
                  : (double)componentsY resolve
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  [self.impl createBlurhashFromImage:imageUri
                         componentsX:componentsX
                         componentsY:componentsY
                            resolver:resolve
                            rejecter:reject];
}

RCT_EXPORT_METHOD(clearCosineCache)
{
  // Not implemented on iOS.
}

- (BlurhashModuleImpl *)impl
{
  if (!_impl) {
    _impl = [[BlurhashModuleImpl alloc] initWithModuleRegistry:_moduleRegistry];
  }
  return _impl;
}

#ifdef RCT_NEW_ARCH_ENABLED

- (std::shared_ptr<TurboModule>)getTurboModule:(const ObjCTurboModule::InitParams &)params
{
  return std::make_shared<NativeBlurhashModuleSpecJSI>(params);
}

#endif

@end
