require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-blurhash"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-blurhash
                   DESC
  s.homepage     = "https://github.com/mrousavy/react-native-blurhash"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Marc Rousavy" => "marcrousavy@hotmail.com" }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => "https://github.com/mrousavy/react-native-blurhash.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency "React-Core"
end

