#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'share_plus'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Share'
  s.description      = <<-DESC
A Flutter plugin to share content from your Flutter app via the platform's share dialog.
Downloaded by pub (not CocoaPods).
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/plus_plugins'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Community Team' => 'authors@fluttercommunity.dev' }
  s.source           = { :http => 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus/share_plus' }
  s.documentation_url = 'https://pub.dev/packages/share_plus'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.weak_framework = 'LinkPresentation'

  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.resource_bundles = {'share_plus_privacy' => ['PrivacyInfo.xcprivacy']}
end

