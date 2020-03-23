Pod::Spec.new do |s|
  s.name         = "SSStorageNode"
  s.version      = "0.0.1"
  s.summary      = "按照节点本地化存储，支持Codeable数据存储"
  s.description  = <<-DESC
                    Hi, SSStorageNode!
                   DESC
  s.homepage     = "git@github.com:kingundertree/SSStorageNode.git"
  s.license      = "MIT"
  s.author       = { "Summer Solstice" => "kingundertree@163.com" }
  s.platform     = :ios, "9.0"
#  s.source       = { :git => "git@github.com:kingundertree/SSStorageNode.git", :tag => "#{s.version}" }
s.source           = { :git => '', :tag => s.version.to_s }

  s.source_files        = 'Sources/*.h'
  s.public_header_files = 'Sources/*.h'
#  s.static_framework = true
#  s.ios.resources = ["Resources/**/*.{png,json}","Resources/*.{html,png,json}", "Resources/*.{xcassets, json}", "Sources/**/*.xib"]

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Core/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Core/*.h'
  end

  s.subspec 'FileStorage' do |ss|
    ss.source_files = 'Sources/FileStorage/*.{h,m,swift}'
    ss.public_header_files = 'Sources/FileStorage/*.h'
  end
  
  s.subspec 'Keychain' do |ss|
    ss.source_files = 'Sources/Keychain/*.{h,m,swift}'
    ss.public_header_files = 'Sources/Keychain/*.h'
  end
  
  s.subspec 'UserDefaults' do |ss|
    ss.source_files = 'Sources/UserDefaults/*.{h,m,swift}'
    ss.public_header_files = 'Sources/UserDefaults/*.h'
  end
  
#  s.dependencies = 'Security.framework'
  
end
