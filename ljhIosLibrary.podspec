Pod::Spec.new do |s|
  s.name             = 'ljhIosLibrary'
  s.version          = '0.1.1'
  s.summary          = 'self iosLibrary.'
  s.homepage         = 'https://github.com/myplxdm/iosLibrary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ljh' => 'myplxdm@163.com' }
  s.source           = { :git => 'https://github.com/myplxdm/iosLibrary.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'iosLibrary/Classes/**/*'
  s.resources = 'iosLibrary/Assets'
  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'AVKit'
  s.dependency 'SDWebImage', '~> 4.0'
  s.dependency 'MyLayout','~> 1.4.1'
#s.dependency 'WZLBadge'
end
