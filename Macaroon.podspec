#
# Be sure to run `pod lib lint macaroon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = 'Macaroon'
  s.version = '0.1.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/Hipo/macaroon'
  s.summary = 'iOS UIKit extension framework for providing structural interface functionality'
  s.source = { :git => 'https://github.com/Hipo/macaroon.git', :tag => s.version.to_s }
  s.author = { 'Hipo' => 'hello@hipolabs.com' }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.default_subspec = 'Sources'

  s.subspec 'Sources' do |ss|
    ss.dependency 'Macaroon/Core'
  end

  s.subspec 'DevSources' do |ss|
    ss.dependency 'Macaroon/Core'
    ss.dependency 'Macaroon/Tryouts'
  end

  s.subspec 'Core' do |ss|
    ss.subspec 'Application' do |sss|
      sss.source_files = 'macaroon/Classes/Core/*.swift'

      sss.subspec 'Analytics' do |ssss|
        ssss.source_files = 'macaroon/Classes/Core/Analytics/*.swift'
      end
    end

    ss.subspec 'Error' do |sss|
      sss.source_files = 'macaroon/Classes/Error/*.swift'
    end

    ss.subspec 'Utils' do |sss|
      sss.source_files = 'macaroon/Classes/Utils/*.swift'

      sss.subspec 'Extensions' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Extensions/*.swift'
      end
    end

    ss.dependency 'SwiftLint', '~> 0.37.0'
  end

  s.subspec 'Tryouts' do |ss|
    ss.source_files = 'macaroon/Classes/Tryouts/*.swift'
    ss.dependency 'Tryouts'
  end
end
