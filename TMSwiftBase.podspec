Pod::Spec.new do |s|
  s.name         = "TMSwiftBase"
  s.version      = "0.0.1"
  s.summary      = "Base Extension & Utils By Swift"
  s.description  = <<-DESC
			iOS 方便开发 一些基础类扩展 以及一些基础Utils 欢迎一起丰富
                   DESC

  s.homepage     = "https://github.com/JoyTomi/TMSwiftBase"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "JoyTomi" => "492774245@qq.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/JoyTomi/TMSwiftBase.git", :tag => "0.0.1" }
  s.source_files  = "Base/**/*.swift"
end