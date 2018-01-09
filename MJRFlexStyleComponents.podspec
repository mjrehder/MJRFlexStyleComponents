Pod::Spec.new do |s|
  s.name             = 'MJRFlexStyleComponents'
  s.version          = '4.1.5'
  s.license          = 'MIT'
  s.summary          = 'Flexible components and views with style'
  s.homepage         = 'https://github.com/mjrehder/MJRFlexStyleComponents.git'
  s.authors          = { 'Martin Jacob Rehder' => 'gitrepocon01@rehsco.com' }
  s.source           = { :git => 'https://github.com/mjrehder/MJRFlexStyleComponents.git', :tag => s.version }
  s.ios.deployment_target = '10.0'

  s.dependency 'DynamicColor'
  s.dependency 'StyledLabel'

  s.framework    = 'UIKit'
  s.source_files = 'MJRFlexStyleComponents/*.swift'
  s.requires_arc = true
end
