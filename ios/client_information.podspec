#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint client_information.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'client_information'
  s.version          = '1.0.0'
  s.summary          = 'A plugin to get the client information.'
  s.description      = <<-DESC
A plugin to get the client information.
                       DESC
  s.homepage         = 'https://github.com/Kent1011/client_information'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kent Chien' => 'kent1011@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SAMKeychain'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
