platform :ios, '10.0'
use_frameworks!

pod 'DynamicColor'
pod 'StyledLabel'

target 'MJRFlexStyleComponents' do
end

target 'MJRFlexStyleExamples' do
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
