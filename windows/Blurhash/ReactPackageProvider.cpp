#include "pch.h"
#include "ReactPackageProvider.h"
#include "ReactPackageProvider.g.cpp"

#include <ModuleRegistration.h>

#include "BlurhashViewManager.h"

using namespace winrt::Microsoft::ReactNative;

namespace winrt::Blurhash::implementation
{

    void ReactPackageProvider::CreatePackage(IReactPackageBuilder const& packageBuilder)
        noexcept
    {
        packageBuilder.AddViewManager(
            L"BlurhashViewManager", []() { return winrt::make<BlurhashViewManager>(); });
    }

} // namespace winrt::ViewManagerSample::implementation
