Pod::Spec.new do |s|
  s.name = "NSDictionary-HYPSafeValue"
  s.version = "0.2"
  s.summary = "Silly NSDictionary crashes when you put NSNull on it"
  s.description = <<-DESC
                   * Silly NSDictionary crashes when you put NSNull on it
                   DESC
  s.homepage = "https://github.com/hyperoslo/NSDictionary-HYPSafeValue"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Elvis Nuñez" => "elvis@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/NSDictionary-HYPSafeValue.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
