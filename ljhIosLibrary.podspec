#
# Be sure to run `pod lib lint iosLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
 s.name             = 'ljhIosLibrary'
 s.version          = '0.2.1'
 s.summary          = 'self iosLibrary.'
 s.homepage         = 'https://github.com/myplxdm/iosLibrary'
 s.license          = { :type => 'MIT', :file => 'LICENSE' }
 s.author           = { 'ljh' => 'myplxdm@163.com' }
 s.source           = { :git => 'https://github.com/myplxdm/iosLibrary.git', :tag => s.version.to_s }
 s.ios.deployment_target = '8.0'

 s.source_files = 'iosLibrary/Classes/**/*'

 # s.resource_bundles = {
 #   'iosLibrary' => ['iosLibrary/Assets/*.png']
 # }

 # s.public_header_files = 'Pod/Classes/**/*.h'
 s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'AVKit'
 s.dependency 'SDWebImage', '~> 4.0'
 s.dependency 'MyLayout','~> 1.4.1'
end
