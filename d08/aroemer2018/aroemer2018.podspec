#
# Be sure to run `pod lib lint aroemer2018.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'aroemer2018'
  s.version          = '0.1.0'
  s.summary          = 'Manage articles'
  s.swift_version = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                    A pod created for the 42 Swift Piscine that manages articles
                       DESC

  s.homepage         = 'https://github.com/aroemer/aroemer2018'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aroemer' => 'aroemer@student.42.fr' }
  s.source           = { :git => 'https://github.com/aroemer/aroemer2018.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.3'

  s.source_files = 'aroemer2018/Classes/**/*'
  
  #s.resource_bundles = {
  #  'aroemer2018' => ['aroemer2018/**/*.xcdatamodeld']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
