Pod::Spec.new do |s|
  s.name         = "LKAssetsLibrary"
  s.version      = "1.1.14"
  s.summary      = "ALAssetLibrary Utilities"
  s.description  = <<-DESC
ALAssetLibrary Utilities.
                   DESC
  s.homepage     = "https://github.com/lakesoft/LKAssetsLibrary"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Hiroshi Hashiguchi" => "xcatsan@mac.com" }
  s.source       = { :git => "https://github.com/lakesoft/LKAssetsLibrary.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/*'

end
