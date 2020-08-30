#pragma once

#include "winrt/Microsoft.ReactNative.h"

namespace winrt::Blurhash::implementation
{
	class BlurhashView
	{
	public:
		BlurhashView(Microsoft::ReactNative::IReactContext const& reactContext);
		winrt::Windows::UI::Xaml::Controls::Image GetView();

	private:
		winrt::Windows::UI::Xaml::Controls::Image _imageView { nullptr };
		Microsoft::ReactNative::IReactContext _reactContext { nullptr };
	};
}

