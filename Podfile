# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'SmartLife-App' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Firebase
    pod 'Firebase/Storage'
    pod 'Firebase/AdMob'
    pod 'Firebase/Auth'
    pod 'Firebase/Crash'
    pod 'Firebase/Database'
    pod 'Firebase/RemoteConfig'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'

    # Pods for SmartLife-App
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Alamofire', '~> 4.4'
    pod 'AlamofireImage', '~> 3.1'
    pod 'AlamofireObjectMapper', '~> 4.0'
    pod 'SnapKit', '~> 3.2.0'
    pod 'TPKeyboardAvoiding'
    pod 'ICSPullToRefresh'
    pod 'PullToRefresher'
    pod 'Repro'
    pod 'AXPhotoViewer', '= 1.3'


    # Prevent alert convert to new swift
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
                config.build_settings['ENABLE_BITCODE'] = 'NO'
                config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
            end
        end
    end

    target 'SmartLife-AppTests' do
        inherit! :search_paths
        # Pods for testing
    end

    target 'SmartLife-AppUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end
