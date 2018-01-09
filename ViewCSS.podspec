#
# Be sure to run `pod lib lint ViewCSS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ViewCSS'
  s.version          = '1.0.0'
  s.summary          = 'IOS Swift CSS implementation'

  s.description      = <<-DESC
ViewCSS is a CSS like plugin for iOS Applications.  It provides a simple
interface to define different attributes for UIView elements.  It is intended
to allow application developers/designers a simple interface to enable CSS
reuse methodologies as well as overriding the values at run-time.  It is NOT
intended to replace auto layout, attributed text, NIBs, etc.
                       DESC

  s.homepage         = 'https://github.com/ericchapman/ViewCSS/wiki'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Chapman' => 'eric.chappy@gmail.com' }
  s.source           = { :git => 'https://github.com/ericchapman/ViewCSS.git', :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ViewCSS/Classes/**/*'
end
