#
# Be sure to run `pod lib lint iosLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
 s.name             = 'ljhIosLibrary'
 s.version          = '0.3.0'
 s.summary          = 'self iosLibrary.'
 s.homepage         = 'https://github.com/ruanqiaohua/iosLibrary'
 s.license          = { :type => 'MIT', :file => 'LICENSE' }
 s.author           = { 'ljh' => 'myplxdm@163.com' }
 s.source           = { :git => 'https://github.com/ruanqiaohua/iosLibrary.git', :tag => s.version.to_s }
 s.ios.deployment_target = '8.0'

 s.source_files = 'iosLibrary/Classes/**/*'
 s.resources = ['iosLibrary/Assets/**/*']

 # s.public_header_files = 'Pod/Classes/**/*.h'
 s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'AVKit', 'CoreGraphics', 'CoreText'
 s.dependency 'SDWebImage'
 s.dependency 'MyLayout'
 s.dependency 'WZLBadge'
 s.dependency 'AFNetworking'
 s.dependency 'YYModel'
 s.dependency 'WechatOpenSDK'
 s.dependency 'JCore'
 s.dependency 'JPush'
 s.dependency 'UMengAnalytics-NO-IDFA'
 s.dependency 'YYCache'
 s.dependency 'SVProgressHUD'
 s.dependency 'IQKeyboardManager'
 s.dependency 'MJRefresh'
end
