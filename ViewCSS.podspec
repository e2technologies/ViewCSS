#
# Be sure to run `pod lib lint ViewCSS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ViewCSS'
  s.version          = '0.5.0'
  s.summary          = 'IOS Swift CSS implementation'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ViewCSS is a CSS like plugin for iOS Applications.  It provides a simple
interface to define different attributes for UIView elements.  It is intended
to allow application developers/designers a simple interface to enable CSS
reuse methodologies as well as overriding the values at run-time.  It is NOT
intended to replace auto layout, attributed text, NIBs, etc.
                       DESC

  s.homepage         = 'https://github.com/ericchapman/ViewCSS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Chapman' => 'eric.chappy@gmail.com' }
  s.source           = { :git => 'https://github.com/ericchapman/ViewCSS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ViewCSS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ViewCSS' => ['ViewCSS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
