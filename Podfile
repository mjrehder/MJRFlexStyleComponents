platform :ios, '10.0'
use_frameworks!

target 'MJRFlexStyleComponents' do
    pod 'DynamicColor'
    pod 'StyledLabel'
end

target 'MJRFlexStyleExamples' do
    pod 'DynamicColor'
    pod 'StyledLabel'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
