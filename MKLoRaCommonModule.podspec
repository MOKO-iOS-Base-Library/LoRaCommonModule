#
# Be sure to run `pod lib lint MKLoRaCommonModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKLoRaCommonModule'
  s.version          = '0.0.8'
  s.summary          = 'A short description of MKLoRaCommonModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MOKO-iOS-Base-Library/MKLoRaCommonModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lovexiaoxia' => 'aadyx2007@163.com' }
  s.source           = { :git => 'git@github.com:MOKO-iOS-Base-Library/MKLoRaCommonModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKLoRaCommonModule' => ['MKLoRaCommonModule/Assets/*.png']
  }
  
  s.subspec 'Views' do |ss|
    ss.subspec 'ReportTimePointCell' do |sss|
      sss.source_files = 'MKLoRaCommonModule/Classes/Views/ReportTimePointCell/**'
    end
    ss.subspec 'TimingModeAddCell' do |sss|
      sss.source_files = 'MKLoRaCommonModule/Classes/Views/TimingModeAddCell/**'
    end
  end
  
  s.subspec 'Pages' do |ss|
    ss.subspec 'MotionModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/MotionModePage/Controller/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/MotionModePage/Protocol'
      end
      sss.subspec 'Protocol' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/MotionModePage/Protocol/**'
      end
    end
    ss.subspec 'PeriodicModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/PeriodicModePage/Controller/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/PeriodicModePage/Protocol'
      end
      sss.subspec 'Protocol' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/PeriodicModePage/Protocol/**'
      end
    end
    ss.subspec 'StandbyModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/StandbyModePage/Controller/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/StandbyModePage/Protocol'
      end
      sss.subspec 'Protocol' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/StandbyModePage/Protocol/**'
      end
    end
    ss.subspec 'TimeSegmentedModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimeSegmentedModePage/Controller/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/TimeSegmentedModePage/View'
        ssss.dependency 'MKLoRaCommonModule/Pages/TimeSegmentedModePage/Protocol'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimeSegmentedModePage/View/**'
      end
      sss.subspec 'Protocol' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimeSegmentedModePage/Protocol/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/TimeSegmentedModePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimeSegmentedModePage/Model/**'
      end
    end
    ss.subspec 'TimingModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimingModePage/Controller/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/TimingModePage/Protocol'
      end
      sss.subspec 'Protocol' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimingModePage/Protocol/**'
        ssss.dependency 'MKLoRaCommonModule/Pages/TimingModePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaCommonModule/Classes/Pages/TimingModePage/Model/**'
      end
    end
    
    ss.dependency 'MKLoRaCommonModule/Views'
  end
  
  s.dependency 'MKBaseModuleLibrary'
  s.dependency 'MKCustomUIModule'
  
  s.dependency 'MLInputDodger'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
