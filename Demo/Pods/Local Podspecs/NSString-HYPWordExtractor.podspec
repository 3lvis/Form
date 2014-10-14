Pod::Spec.new do |s|
  s.name = "NSString-HYPWordExtractor"
  s.version = "1.0"
  s.summary = "A super easy way of extracting all or only unique words from an NSString"
  s.description = <<-DESC
                   * A super easy way of extracting all or only unique words from an NSString
                   DESC
  s.homepage = "https://github.com/hyperoslo/NSString-HYPWordExtractor"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper Interaktiv" => "teknologi@hyper.no" }
  s.social_media_url = "https://twitter.com/hyperoslo"
  s.platform = :ios, '6.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/NSString-HYPWordExtractor.git',
    :tag => s.version.to_s
  }
  s.source_files = 'Source/'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
