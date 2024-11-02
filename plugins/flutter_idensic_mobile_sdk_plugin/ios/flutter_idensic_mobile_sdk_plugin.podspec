#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_idensic_mobile_sdk_plugin.podspec' to validate before publishing.
#

require "yaml"

package = YAML.load_file(File.join(__dir__, "/../pubspec.yaml"))
sdk_version = "1.32.0"

Pod::Spec.new do |s|
  s.name             = package["name"]
  s.version          = package["version"]
  s.summary          = package["name"]
  s.description      = package["description"]
  s.homepage         = package["homepage"]
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SumSub' => 'support@sumsub.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  s.platform         = :ios, '12.0'

  s.dependency 'Flutter'
  s.dependency 'IdensicMobileSDK', '=' + sdk_version

  if ENV['IDENSIC_WITH_EID']
    s.dependency 'IdensicMobileSDK/EID', "=" + sdk_version
  end
  if ENV['IDENSIC_WITH_MRTDREADER_COMPAT']
    s.dependency 'IdensicMobileSDK/MRTDReader-compat', "=" + sdk_version
  elsif ENV['IDENSIC_WITH_MRTDREADER']
    s.dependency 'IdensicMobileSDK/MRTDReader', '=' + sdk_version
  end
  if ENV['IDENSIC_WITH_VIDEOIDENT_COMPAT']
    s.dependency 'IdensicMobileSDK/VideoIdent-compat', "=" + sdk_version
  elsif ENV['IDENSIC_WITH_VIDEOIDENT']
    s.dependency 'IdensicMobileSDK/VideoIdent', "=" + sdk_version
    s.platform = :ios, '12.2'
  end

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
