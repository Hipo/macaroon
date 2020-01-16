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
  s.default_subspec = 'Production'

  s.subspec 'Production' do |ss|
    ss.dependency 'Macaroon/Core'
  end

  s.subspec 'Development' do |ss|
    ss.dependency 'Macaroon/Core'
    ss.dependency 'Macaroon/Tryouts'
    ss.dependency 'Macaroon/SwiftLint'
  end

  s.subspec 'Core' do |ss|
    ss.subspec 'Application' do |sss|
      sss.source_files = 'macaroon/Classes/Application/*.swift'
    end

    ss.subspec 'Data' do |sss|
      sss.source_files = 'macaroon/Classes/Data/*.swift'

      sss.subspec 'DataSources' do |ssss|
        ssss.source_files = 'macaroon/Classes/Data/DataSources/*.swift'

        ssss.subspec 'List' do |sssss|
          sssss.source_files = 'macaroon/Classes/Data/DataSources/List/*.swift'
        end
      end
    end

    ss.subspec 'Error' do |sss|
      sss.source_files = 'macaroon/Classes/Error/*.swift'
    end

    ss.subspec 'Screens' do |sss|
      sss.source_files = 'macaroon/Classes/Screens/*.swift'

      sss.subspec 'Configuration' do |ssss|
        ssss.subspec 'NavigationBar' do |sssss|
          sssss.source_files = 'macaroon/Classes/Screens/Configuration/NavigationBar/*.swift'
        end

        ssss.subspec 'StatusBar' do |sssss|
          sssss.source_files = 'macaroon/Classes/Screens/Configuration/StatusBar/*.swift'
        end
      end

      sss.subspec 'Containers' do |ssss|
        ssss.source_files = 'macaroon/Classes/Screens/Containers/*.swift'
      end

      sss.subspec 'List' do |ssss|
        ssss.source_files = 'macaroon/Classes/Screens/List/*.swift'
      end
    end

    ss.subspec 'Utils' do |sss|
      sss.source_files = 'macaroon/Classes/Utils/*.swift'

      sss.subspec 'Extensions' do |sss|
        sss.subspec 'Foundation' do |ssss|
          ssss.source_files = 'macaroon/Classes/Utils/Extensions/Foundation/*.swift'
        end

        sss.subspec 'UI' do |ssss|
          ssss.source_files = 'macaroon/Classes/Utils/Extensions/UI/*.swift'
        end
      end

      sss.subspec 'Notification' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Notification/*.swift'
      end

      sss.subspec 'Text' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Text/*.swift'

        ssss.subspec 'Attributed' do |sssss|
          sssss.source_files = 'macaroon/Classes/Utils/Text/Attributed/*.swift'
        end
      end
    end

    ss.subspec 'Views' do |sss|
      sss.source_files = 'macaroon/Classes/Views/*.swift'

      sss.subspec 'Custom' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/Custom/*.swift'

        ssss.subspec 'List' do |sssss|
          sssss.source_files = 'macaroon/Classes/Views/Custom/List/*.swift'
        end
      end

      sss.subspec 'Layout' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/Layout/*.swift'

        ssss.subspec 'List' do |sssss|
          sssss.source_files = 'macaroon/Classes/Views/Layout/List/*.swift'
        end
      end

      sss.subspec 'Styling' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/Styling/*.swift'
      end

      sss.subspec 'ViewModel' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/ViewModel/*.swift'
      end
    end

    ss.dependency 'SnapKit', '~> 5.0.0'
  end

  s.subspec 'SwiftLint' do |ss|
    ss.dependency 'SwiftLint', '~> 0.37.0'
  end

  s.subspec 'TabBar' do |ss|
    ss.source_files = 'macaroon/Classes/TabBar/*.swift'

    ss.subspec 'Configuration' do |sss|
      sss.source_files = 'macaroon/Classes/TabBar/Configuration/*.swift'
    end

    ss.subspec 'Views' do |sss|
      sss.source_files = 'macaroon/Classes/TabBar/Views/*.swift'
    end
  end

  s.subspec 'Tryouts' do |ss|
    ss.source_files = 'macaroon/Classes/Tryouts/*.swift'
    ss.dependency 'Tryouts'
  end
end
