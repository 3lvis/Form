Pod::Spec.new do |s|
  s.name = "UIColor-ANDYHex"
  s.version = "1.0"
  s.summary = "Create colors using hexadecimal"
  s.description = <<-DESC
                   * Create colors using hexadecimal
                   DESC
  s.homepage = "https://github.com/NSElvis/UIColor-ANDYHex"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Elvis Nuñez" => "elvisnunez@me.com" }
  s.social_media_url = "http://twitter.com/NSElvis"
  s.platform = :ios, '6.0'
  s.source = {
    :git => 'https://github.com/NSElvis/UIColor-ANDYHex.git',
    :tag => s.version.to_s
  }
  s.source_files = 'UIColor-ANDYHex/'
  s.frameworks = 'UIKit'
  s.requires_arc = true
end
