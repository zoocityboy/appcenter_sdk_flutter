#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appcenter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appcenter_sdk'
  s.version          = '1.0.0'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Embedit, s.r.o' => 'e-lukas.svoboda@embedit.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  # App center
  s.dependency 'AppCenter'
  s.dependency 'AppCenter/Analytics'
  s.dependency 'AppCenter/Crashes'
  s.dependency 'AppCenter/Distribute'

  s.ios.deployment_target = '12.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
