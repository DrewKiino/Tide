Pod::Spec.new do |s|
 
  # 1
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Tide"
  s.summary = "Tide is an image processing library."
  s.requires_arc = true
 
  # 2
  s.version = "0.1.0"
 
  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  # 4 - Replace with your name and e-mail address
  s.author = { "[Andrew Aquino]" => "[andrew@totemv.com]" }
 
  # For example,
  # s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }
 
 
  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "[http://totemv.com/drewkiino.github.io/index.html]"
 
  # For example,
  # s.homepage = "https://github.com/JRG-Developer/Tide"
 
 
  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "[https://github.com/DrewKiino/Tide.git]", :tag => "#{s.version}"}
 
  # For example,
  # s.source = { :git => "https://github.com/JRG-Developer/Tide.git", :tag => "#{s.version}"}
 
 
  # 7
  s.framework = "UIKit"
 
  # 8
  s.source_files = "Tide/**/*.{swift}"
 
  # 9
  s.resources = "Tide/**/*.{png,jpeg,jpg,storyboard,xib}"
end