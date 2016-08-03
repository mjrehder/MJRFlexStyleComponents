Pod::Spec.new do |s|
  s.name             = 'MJRFlexStyleComponents'
  s.version          = '1.0.3'
  s.license          = 'MIT'
  s.summary          = 'Sliding components with style'
  s.homepage         = 'https://github.com/mjrehder/MJRFlexStyleComponents.git'
  s.authors          = { 'Martin Jacob Rehder' => 'gitrepocon01@rehsco.com' }
  s.source           = { :git => 'https://github.com/mjrehder/MJRFlexStyleComponents.git', :tag => s.version }
  s.ios.deployment_target = '9.0'

  s.dependency 'SnappingStepper', '~> 2.3.1'

  s.framework    = 'UIKit'
  s.source_files = 'MJRFlexStyleComponents/*.swift'
  s.requires_arc = true
end
