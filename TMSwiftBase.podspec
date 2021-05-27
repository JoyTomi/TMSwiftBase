 Pod::Spec.new do |spec|
    spec.name             = 'TMSwiftBase'
    spec.version          = "0.0.2"
    spec.license          = { :type => 'MIT' }
    spec.homepage         = "https://github.com/JoyTomi/TMSwiftBase"
    spec.authors          = { "JoyTomi" => "492774245@qq.com" }
    spec.summary          = "Base Extension & Utils By Swift"
    spec.source           = {:git => 'https://github.com/JoyTomi/TMSwiftBase.git', :tag => "0.0.2"}
    spec.platform         = :ios, '13.0'
    spec.swift_version    = '5.0'
    spec.ios.deployment_target = '13.0'
    spec.framework        = 'UIKit'
    spec.source_files  = "Base/**/*.swift"
end