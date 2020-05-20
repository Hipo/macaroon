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

  s.subspec 'Banner' do |ss|
    ss.source_files = 'macaroon/Classes/Banner/*.swift'
  end

  s.subspec 'Core' do |ss|
    ss.subspec 'Application' do |sss|
      sss.source_files = 'macaroon/Classes/Application/*.swift'

      sss.subspec 'Routing' do |ssss|
        ssss.source_files = 'macaroon/Classes/Application/Routing/*.swift'
      end
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

      sss.subspec 'Image' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Image/*.swift'
      end

      sss.subspec 'List' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/List/*.swift'
      end

      sss.subspec 'Notification' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Notification/*.swift'
      end

      sss.subspec 'Performance' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Performance/*.swift'
      end

      sss.subspec 'Presentables' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Presentables/*.swift'
      end

      sss.subspec 'Text' do |ssss|
        ssss.source_files = 'macaroon/Classes/Utils/Text/*.swift'

        ssss.subspec 'Attributed' do |sssss|
          sssss.source_files = 'macaroon/Classes/Utils/Text/Attributed/*.swift'
        end
      end
    end

    ss.subspec 'Views' do |sss|
      sss.subspec 'BaseComponents' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/BaseComponents/*.swift'
      end

      sss.subspec 'Components' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/Components/*.swift'
      end

      sss.subspec 'Configuration' do |ssss|
        ssss.subspec 'Data' do |sssss|
          sssss.source_files = 'macaroon/Classes/Views/Configuration/Data/*.swift'
        end

        ssss.subspec 'Layout' do |sssss|
          sssss.source_files = 'macaroon/Classes/Views/Configuration/Layout/*.swift'
        end

        ssss.subspec 'Styling' do |sssss|
          sssss.source_files = 'macaroon/Classes/Views/Configuration/Styling/*.swift'

          sssss.subspec 'Customization' do |ssssss|
            ssssss.source_files = 'macaroon/Classes/Views/Configuration/Styling/Customization/*.swift'
          end
        end
      end

      sss.subspec 'ListComponents' do |ssss|
        ssss.source_files = 'macaroon/Classes/Views/ListComponents/*.swift'
      end
    end

    ss.dependency 'SnapKit', '~> 5.0.0'
  end

  s.subspec 'Form' do |ss|
    ss.subspec 'Screens' do |sss|
      sss.source_files = 'macaroon/Classes/Form/Screens/*.swift'
    end

    ss.subspec 'Utils' do |sss|
      sss.source_files = 'macaroon/Classes/Form/Utils/*.swift'
    end

    ss.subspec 'Views' do |sss|
      sss.source_files = 'macaroon/Classes/Form/Views/*.swift'
    end
  end

  s.subspec 'MediaPicker' do |ss|
    ss.source_files = 'macaroon/Classes/MediaPicker/*.swift'
  end

  s.subspec 'PushNotification' do |ss|
    ss.source_files = 'macaroon/Classes/PushNotification/*.swift'
  end

  s.subspec 'SVGImage' do |ss|
    ss.source_files = 'macaroon/Classes/SVGImage/*.swift'

    ss.dependency 'Macaroon/URLImage'
    ss.dependency 'Macaw', '0.9.6'
  end

  s.subspec 'SwiftLint' do |ss|
    ss.dependency 'SwiftLint', '~> 0.37.0'
  end

  s.subspec 'TabBar' do |ss|
    ss.source_files = 'macaroon/Classes/TabBar/*.swift'
  end

  s.subspec 'Tryouts' do |ss|
    ss.source_files = 'macaroon/Classes/Tryouts/*.swift'
    ss.dependency 'Tryouts'
  end

  s.subspec 'URLImage' do |ss|
    ss.source_files = 'macaroon/Classes/URLImage/*.swift'

    ss.subspec 'Utils' do |sss|
      sss.source_files = 'macaroon/Classes/URLImage/Utils/*.swift'

      sss.subspec 'Extensions' do |ssss|
        ssss.source_files = 'macaroon/Classes/URLImage/Utils/Extensions/*.swift'
      end

      sss.subspec 'Properties' do |ssss|
        ssss.source_files = 'macaroon/Classes/URLImage/Utils/Properties/*.swift'
      end
    end

    ss.subspec 'ViewModels' do |sss|
      sss.source_files = 'macaroon/Classes/URLImage/ViewModels/*.swift'
    end

    ss.subspec 'Views' do |sss|
      sss.subspec 'Components' do |ssss|
        ssss.source_files = 'macaroon/Classes/URLImage/Views/Components/*.swift'
      end

      sss.subspec 'Configuration' do |ssss|
        ssss.subspec 'Styling' do |sssss|
          sssss.source_files = 'macaroon/Classes/URLImage/Views/Configuration/Styling/*.swift'
        end
      end
    end

    ss.dependency 'Kingfisher', '~> 5.0'
  end

  s.subspec 'Zendesk-Support' do |ss|
    ss.source_files = 'macaroon/Classes/ZendeskSupport/*.swift'

    ss.dependency 'ZendeskSupportSDK', '~> 5.0'
  end
end
