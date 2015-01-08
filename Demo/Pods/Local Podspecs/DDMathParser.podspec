Pod::Spec.new do |s|
  s.name = "DDMathParser"
  s.version = "0.1"
  s.summary = "NSString → NSNumber"
  s.description = <<-DESC
                   * NSString → NSNumber
                   DESC
  s.homepage = "https://github.com/hyperoslo/DDMathParser"
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE.md'
  }
  s.author = { "Hyper" => "teknologi@hyper.no" }
  s.social_media_url = "http://twitter.com/hyperoslo"
  s.platform = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/hyperoslo/DDMathParser.git',
    :tag => s.version.to_s
  }
  s.source_files = 'DDMathParser/*.{h,m}'
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
