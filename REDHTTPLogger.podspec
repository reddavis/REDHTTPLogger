#
# Be sure to run `pod lib lint REDHTTPLogger.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "REDHTTPLogger"
  s.version          = "0.2.0"
  s.summary          = "REDHTTPLogger makes it easy to inspect HTTP requests happening inside your iOS app without needed the debugger attached."
#s.description      = <<-DESC
#
#                       DESC
  s.homepage         = "https://github.com/reddavis/REDHTTPLogger"
  s.license          = 'MIT'
  s.author           = { "Red Davis" => "me@red.to" }
  s.source           = { :git => "https://github.com/reddavis/REDHTTPLogger.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/reddavis'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'REDHTTPLogger' => ['Pod/Assets/*.png']
  }

    s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit'
    s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'RequestUtils', '~> 1.1'
end
