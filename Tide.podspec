Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Tide"
  s.summary = "Tide is an image processing library."
  s.requires_arc = true
  s.version = "0.1.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "[Andrew Aquino]" => "[andrew@totemv.com]" }
  s.homepage = 'http://totemv.com/drewkiino.github.io'
  s.framework = "UIKit"
  s.source = { :git => 'https://github.com/DrewKiino/Tide.git', :tag => 'master' }
  #s.source_files = "Tide/**/*.{swift}"
  s.source_files = "Tide/Source/*.{swift}"

end