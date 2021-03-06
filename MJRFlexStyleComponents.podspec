Pod::Spec.new do |s|
  s.name             = 'MJRFlexStyleComponents'
  s.version          = '5.0.2'
  s.license          = 'MIT'
  s.summary          = 'Flexible components and views with style'
  s.homepage         = 'https://github.com/mjrehder/MJRFlexStyleComponents.git'
  s.authors          = { 'Martin Jacob Rehder' => 'gitrepocon01@rehsco.com' }
  s.source           = { :git => 'https://github.com/mjrehder/MJRFlexStyleComponents.git', :tag => s.version }
  s.swift_version    = '5.0'
  s.ios.deployment_target = '10.0'

  s.dependency 'StyledLabel'

  s.framework    = 'UIKit'
  s.source_files = 'MJRFlexStyleComponents/*.swift'
  s.resources    = 'MJRFlexStyleComponents/*.xcassets'
  s.requires_arc = true
end
