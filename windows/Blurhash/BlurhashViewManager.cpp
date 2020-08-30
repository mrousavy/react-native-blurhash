#include "pch.h"

#include "BlurhashViewManager.h"
#include "NativeModules.h"
#include "BlurhashView.h"
#include "JSValueXaml.h"

namespace winrt
{
    using namespace Microsoft::ReactNative;
    using namespace Windows::Foundation;
    using namespace Windows::Foundation::Collections;
    using namespace Windows::UI;
    using namespace Windows::UI::Xaml;
    using namespace Windows::UI::Xaml::Controls;
}

namespace winrt::Blurhash::implementation
{
    // IViewManager
    hstring BlurhashViewManager::Name() noexcept
    {
        return L"BlurhashView";
    }

    FrameworkElement BlurhashViewManager::CreateView() noexcept
    {
        _blurhashView = *winrt::make_self<BlurhashView>(_reactContext);
        return _blurhashView;
    }

    // IViewManagerWithNativeProperties
    IMapView<hstring, ViewManagerPropertyType> BlurhashViewManager::NativeProps() noexcept
    {
        auto nativeProps = winrt::single_threaded_map<hstring, ViewManagerPropertyType>();

        nativeProps.Insert(L"blurhash", ViewManagerPropertyType::String);
        nativeProps.Insert(L"decodeWidth", ViewManagerPropertyType::Number);
        nativeProps.Insert(L"decodeHeight", ViewManagerPropertyType::Number);
        nativeProps.Insert(L"decodePunch", ViewManagerPropertyType::Number);
        nativeProps.Insert(L"decodeAsync", ViewManagerPropertyType::Boolean);
        nativeProps.Insert(L"resizeMode", ViewManagerPropertyType::String);

        return nativeProps.GetView();
    }

    void BlurhashViewManager::UpdateProperties(
        FrameworkElement const& view,
        IJSValueReader const& propertyMapReader) noexcept
    {
        if (auto control = view.try_as<winrt::Blurhash::implementation::BlurhashView>())
        {
            // TODO: Properties
            const JSValueObject& propertyMap = JSValue::ReadObjectFrom(propertyMapReader);

            for (auto const& pair : propertyMap)
            {
                auto const& propertyName = pair.first;
                auto const& propertyValue = pair.second;

                if (propertyName == "label")
                {
                    if (propertyValue != nullptr)
                    {
                        auto const& value = winrt::box_value(winrt::to_hstring(propertyValue.String()));
                        control.SetValue(winrt::Blurhash::BlurhashView::LabelProperty(), propertyValue);
                    }
                    else
                    {
                        control.ClearValue(winrt::Blurhash::BlurhashView::LabelProperty());
                    }
                }
                else if (propertyName == "color")
                {
                    if (auto value = propertyValue.To<Brush>())
                    {
                        control.SetValue(Control::ForegroundProperty(), value);
                    }
                    else
                    {
                        control.ClearValue(Control::ForegroundProperty());
                    }
                }
                else if (propertyName == "backgroundColor")
                {
                    if (auto value = propertyValue.To<Brush>())
                    {
                        control.SetValue(Control::BackgroundProperty(), value);
                    }
                    else
                    {
                        control.ClearValue(Control::BackgroundProperty());
                    }
                }
            }
        }
    }
}
