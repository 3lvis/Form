Pod::Spec.new do |s|
  s.name = "NSString-HYPContainsString"
  s.version = "0.1"
  s.summary = "API similar to containsString found in iOS8, compatible with iOS7"
  s.description = <<-DESC
                   * API similar to containsString found in iOS8, compatible with iOS7
                   DESC
  s.homepage = "https://github.com/hyperoslo/NSString-HYPContainsString"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv" => "teknologi@hyper.no" }
  s.social_media_url = "https://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/NSString-HYPContainsString.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
