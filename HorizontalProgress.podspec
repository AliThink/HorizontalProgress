Pod::Spec.new do |s|
  s.name         = "HorizontalProgress"
  s.version      = "0.1.1"
  s.summary      = "Simple horizontal progress bar with animation"
  s.homepage     = "https://github.com/AliThink/HorizontalProgress"
  s.license      = "MIT"
  s.author             = { "AliThink" => "cloudsthinker@126.com" }
  s.source       = { :git => "https://github.com/AliThink/HorizontalProgress.git", :tag => "0.1.1" }
  s.source_files  = "HorizontalProgress/**/*.{h,m}"
  s.platform      = :ios, '7.0'
  s.requires_arc  = true
end
