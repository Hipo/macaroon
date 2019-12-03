#
# Be sure to run `pod lib lint macaroon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'macaroon'
  s.version          = '0.1.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage         = 'https://github.com/sakkaras/macaroon'
  s.summary          = 'iOS UIKit extension framework for providing structural interface functionality'
  s.source           = { :git => 'https://github.com/Hipo/macaroon', :tag => s.version.to_s }
  s.author           = { 'Hipo' => 'hello@hipolabs.com' }
  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.0'
  s.source_files = 'macaroon/Classes/**/*'
end
