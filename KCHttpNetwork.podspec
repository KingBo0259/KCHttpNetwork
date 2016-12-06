#
# Be sure to run `pod lib lint KCHttpNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KCHttpNetwork'
  s.version          = '0.0.7'
  s.summary          = '快货运网络层封装库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                 主要封装了网络层，提供各个模块使用
                       DESC

  s.homepage         = 'https://github.com/KingBo0259/KCHttpNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jinlb' => 'jlb@kuaihuoyun.com' }
  s.source           = { :git => 'https://github.com/KingBo0259/KCHttpNetwork.git', :tag => "#{s.version}" }


  s.ios.deployment_target = '8.0'

  s.source_files = 'KCHttpNetwork/Classes/**/*'
  
  #  s.resource_bundles = {
  #  'KCHttpNetwork' => ['KCHttpNetwork/Assets/*.png']
  #  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~>2.6.0'
  s.dependency 'JSONModel', '~> 1.2.0'
end
