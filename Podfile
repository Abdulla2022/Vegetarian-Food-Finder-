# Uncomment the next line to define a global platform for your project
  platform :ios, '9.0'

target 'Vegetarian-Food-Finder' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for Vegetarian-Food-Finder
  pod 'Parse'
  pod 'GooglePlaces', '7.0.0'
  pod 'CLTypingLabel'
   # try this to remove -pie warnings
  #https://stackoverflow.com/questions/52789127/how-to-remove-warning-pie-being-ignored-it-is-only-used-when-linking-a-main
#  post_install do |installer|
#      installer.pods_project.targets.each do |target|
#          target.build_configurations.each do |config|
#              config.build_settings['LD_NO_PIE'] = 'NO'
#              config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
#              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#              if target.name == 'Flurry-iOS-SDK'
#                  target.build_configurations.each do |config|
#                      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
#                  end
#              end
#          end
#      end
#  end
  target 'Vegetarian-Food-FinderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Vegetarian-Food-FinderUITests' do
    # Pods for testing
  end
 
end
