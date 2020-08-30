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
	using namespace Windows::UI::Xaml::Media;
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
		_blurhashView = winrt::make_self<BlurhashView>
			(_reactContext);
		return _blurhashView->GetView();
	}

	// IViewManagerWithReactContext
	winrt::IReactContext BlurhashViewManager::ReactContext() noexcept
	{
		return _reactContext;
	}

	void BlurhashViewManager::ReactContext(IReactContext reactContext) noexcept
	{
		_reactContext = reactContext;
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
		if (auto blurhashView = view.try_as<winrt::Blurhash::implementation::BlurhashView>())
		{
			// TODO: Properties
			const JSValueObject& propertyMap = JSValue::ReadObjectFrom(propertyMapReader);

			for (auto const& pair : propertyMap)
			{
				auto const& propertyName = pair.first;
				auto const& propertyValue = pair.second;

				if (propertyName == "blurhash") {
					if (propertyValue != nullptr)
					{
						SolidColorBrush brush = SolidColorBrush(winrt::Colors::AliceBlue());
						blurhashView->Background(brush);
						/*
						auto const& value = winrt::box_value(winrt::to_hstring(propertyValue.String()));
						blurhashView.SetValue(winrt::Blurhash::BlurhashView::LabelProperty(), propertyValue);
						*/
					}
					else
					{
						//blurhashView.ClearValue(winrt::Blurhash::BlurhashView::LabelProperty());
					}
				}
			}
		}
	}
}
