#
# Be sure to run `pod lib lint WhisperFpProv.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WhisperFpProv'
  s.version          = '1.0.6'
  s.summary          = 'WhisperFpProv simple common tool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    WhisperFpProv 是一个用于保存一些常用工具类的工具
                       DESC

  s.homepage         = 'https://github.com/WhisperFp/WhisperTunpProject'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WhisperFp' => 'tourse@163.com' }
  s.source           = { :git => 'https://github.com/yipingxu/WhisperTunpProject.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WhisperFpProv/Classes/**/*.{h,m}'
  
#   s.resource_bundles = {
#     'WhisperFpProv' => ['WhisperFpProv/Assets/*.xcassets']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
   
   s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
   
end
