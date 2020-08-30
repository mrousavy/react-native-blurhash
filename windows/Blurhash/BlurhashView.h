#pragma once

#include "winrt/Microsoft.ReactNative.h"
#include "NativeModules.h"
#include "BlurhashView.g.h"

namespace winrt::Blurhash::implementation
{
	class BlurhashView : public BlurhashViewT<BlurhashView>
	{
	public:
		BlurhashView(Microsoft::ReactNative::IReactContext const& reactContext);
		winrt::Windows::UI::Xaml::Controls::Image GetView();

	private:
		winrt::Windows::UI::Xaml::Controls::Image _imageView { nullptr };
		Microsoft::ReactNative::IReactContext _reactContext { nullptr };
	};
}

namespace winrt::Blurhash::factory_implementation
{
	struct BlurhashView : BlurhashViewT<BlurhashView, implementation::BlurhashView> {};
} // namespace winrt::Blurhash::factory_implementation