#ifdef RCT_NEW_ARCH_ENABLED

#import "BlurhashViewComponentView.h"

#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>

#import <react/renderer/components/blurhash_codegen/ComponentDescriptors.h>
#import <react/renderer/components/blurhash_codegen/EventEmitters.h>
#import <react/renderer/components/blurhash_codegen/Props.h>
#import <react/renderer/components/blurhash_codegen/RCTComponentViewHelpers.h>

#if __has_include("react_native_blurhash/react_native_blurhash-Swift.h")
#import "react_native_blurhash/react_native_blurhash-Swift.h"
#else
#import "react_native_blurhash-Swift.h"
#endif

using namespace facebook::react;

static UIViewContentMode convertResizeMode(const BlurhashViewResizeMode &resizeMode)
{
  switch (resizeMode) {
    case BlurhashViewResizeMode::Contain:
      return UIViewContentMode::UIViewContentModeScaleAspectFit;
    case BlurhashViewResizeMode::Cover:
      return UIViewContentMode::UIViewContentModeScaleAspectFill;
    case BlurhashViewResizeMode::Stretch:
      return UIViewContentMode::UIViewContentModeScaleToFill;
    case BlurhashViewResizeMode::Center:
      return UIViewContentMode::UIViewContentModeCenter;
  }
}

@interface BlurhashViewComponentView () <RCTBlurhashViewViewProtocol, BlurhashViewDelegate>
@end

@implementation BlurhashViewComponentView {
  BlurhashView *_blurhashView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = BlurhashViewShadowNode::defaultSharedProps();
    _props = defaultProps;
    _blurhashView = [[BlurhashView alloc] initWithFrame:self.bounds];
    _blurhashView.delegate = self;

    self.contentView = _blurhashView;
  }

  return self;
}

#pragma mark - RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<BlurhashViewComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  const auto &oldViewProps = static_cast<const BlurhashViewProps &>(*_props);
  const auto &newViewProps = static_cast<const BlurhashViewProps &>(*props);

  if (oldViewProps.blurhash != newViewProps.blurhash) {
    _blurhashView.blurhash = RCTNSStringFromString(newViewProps.blurhash);
  }
  if (oldViewProps.decodeWidth != newViewProps.decodeWidth) {
    _blurhashView.decodeWidth = newViewProps.decodeWidth;
  }
  if (oldViewProps.decodeHeight != newViewProps.decodeHeight) {
    _blurhashView.decodeHeight = newViewProps.decodeHeight;
  }
  if (oldViewProps.decodePunch != newViewProps.decodePunch) {
    _blurhashView.decodePunch = newViewProps.decodePunch;
  }
  if (oldViewProps.decodeAsync != newViewProps.decodeAsync) {
    _blurhashView.decodeAsync = newViewProps.decodeAsync;
  }
  if (oldViewProps.resizeMode != newViewProps.resizeMode) {
    _blurhashView.contentMode = convertResizeMode(newViewProps.resizeMode);
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask
{
  [super finalizeUpdates:updateMask];

  [_blurhashView finalizeUpdates];
}

- (void)blurhashViewLoadDidStart
{
  static_cast<const BlurhashViewEventEmitter &>(*_eventEmitter).onLoadStart(BlurhashViewEventEmitter::OnLoadStart{});
}

- (void)blurhashViewLoadDidEnd
{
  static_cast<const BlurhashViewEventEmitter &>(*_eventEmitter).onLoadEnd(BlurhashViewEventEmitter::OnLoadEnd{});
}

- (void)blurhashViewLoadDidError:(NSString *)message
{
  static_cast<const BlurhashViewEventEmitter &>(*_eventEmitter)
      .onLoadError(BlurhashViewEventEmitter::OnLoadError{RCTStringFromNSString(message)});
}

@end

Class<RCTComponentViewProtocol> BlurhashViewCls(void)
{
  return BlurhashViewComponentView.class;
}

#endif // RCT_NEW_ARCH_ENABLED
