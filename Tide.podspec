Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Tide"
  s.summary = "Tide is an image processing library."
  s.requires_arc = true
  s.version = "1.2.8"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "[Andrew Aquino]" => "[andrew@totemv.com]" }
  s.homepage = 'http://totemv.com/drewkiino'
  s.framework = "UIKit"
  s.source = { :git => 'https://github.com/DrewKiino/Tide.git', :tag => 'master' }

  s.dependency 'AsyncSwift', '1.7.4'
  s.dependency 'SDWebImage', '3.8.0'

  s.source_files = "Tide/Source/*.{swift}"

end