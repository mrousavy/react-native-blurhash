#include "pch.h"
#include "JSValueXaml.h"
#include "BlurhashView.h"
#include "BlurhashView.g.cpp"

namespace winrt
{
    using namespace Microsoft::ReactNative;
    using namespace Windows::Foundation;
    using namespace Windows::UI;
    using namespace Windows::UI::Popups;
    using namespace Windows::UI::Xaml;
    using namespace Windows::UI::Xaml::Controls;
    using namespace Windows::UI::Xaml::Input;
    using namespace Windows::UI::Xaml::Media;
} // namespace winrt

namespace winrt::Blurhash::implementation
{
    BlurhashView::BlurhashView(winrt::IReactContext const& reactContext): _reactContext(reactContext)
    {
        _imageView= winrt::Image();
    }

    winrt::Windows::UI::Xaml::Controls::Image BlurhashView::GetView()
    {
        return _imageView;
    }
}